const geolib = require('geolib');
const axios = require('axios');
const AWS = require('aws-sdk');
var crypto = require('crypto');
var ssmincidents = new AWS.SSMIncidents();

const url = process.env.BMKG_ENDPOINT
let anchorLat = process.env.ANCHOR_LATITUDE
let anchorLong = process.env.ANCHOR_LONGITUDE
let notifyRadiusInKm = process.env.NOTIFY_RADIUS_IN_KM
let minimumSR = process.env.MINIMUM_SR
const anchorPoint = { latitude: anchorLat, longitude: anchorLong };

const escalationPlanArn = process.env.ESCALATION_PLAN_ARN;

let declareIncident = async (msg, gempa) => {
    var datetime = new Date();
    let seed = msg + datetime.toISOString().slice(0, 10)
    let clientToken = crypto.createHash('sha256').update(seed).digest('hex');
    console.log(clientToken)

    var params = {
        incidentTemplate: {
            impact: 1,
            title: 'gempa',
        },
        name: 'gempa',
        clientToken: clientToken,
        engagements: [
            escalationPlanArn
        ],
    };
    let response = await ssmincidents.createResponsePlan(params).promise();

    let responsePlanArn = response.arn

    var params = {
        responsePlanArn: responsePlanArn,
        title: msg,
        clientToken: clientToken,
    };
    response = await ssmincidents.startIncident(params).promise();

    console.log(response)

    let incidentRecordArn = response.incidentRecordArn

    gempa.Shakemap = "https://data.bmkg.go.id/DataMKG/TEWS/" + gempa.Shakemap

    var params = {
        arn: incidentRecordArn,
        summary: JSON.stringify(gempa),
        clientToken: clientToken,
    };

    await ssmincidents.updateIncidentRecord(params).promise();

    var params = {
        arn: responsePlanArn,
    };

    await ssmincidents.deleteResponsePlan(params).promise();
}

exports.handler = async (event) => {
    let res = await axios.get(url)
    

    let gempa = res.data.Infogempa.gempa

    let coordinates = gempa.Coordinates.split(",")
    let latitude = coordinates[0]
    let longitude = coordinates[1]

    let distance = geolib.getDistance(
        { latitude: latitude, longitude: longitude },
        anchorPoint
    );

    let distanceInKm = Math.floor(distance / 1000)

    let msg = "Gempa " + gempa?.Magnitude + " SR " + gempa?.Wilayah + " pukul " + gempa?.Jam + " jarak " + distanceInKm + " KM"

    if (distanceInKm <= notifyRadiusInKm && gempa?.Magnitude >= minimumSR) {
        await declareIncident(msg, gempa)
    }

}
