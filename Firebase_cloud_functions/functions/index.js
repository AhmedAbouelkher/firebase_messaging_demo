const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);
var snapshotData;

exports.myTrigger = functions.firestore.document('orders/{orderID}').onCreate(
    async (snapshot, context) => {
        const message = snapshot.data().message;
        const orderID = 464654;
        console.log('Message', message);
        if (snapshot.empty) {
            console.log('No Devices');
            return;
        }
        var tokens = [];
        snapshotData = snapshot.data();
        const deviceIDTokens = await admin.firestore().collection("device_tokens").get();
        for (const token of deviceIDTokens.docs) {
            tokens.push(token.data().device_token);
        }
        var payload = {
            notification: {
                title: 'Push Title',
                body: 'Push Body',
                sound: 'default',
            },
            data: {
                click_action: "FLUTTER_NOTIFICATION_CLICK",
                message: snapshotData.message,
            },
        };

        var payload_elhariry = {
            notification: {
                title: `New Order`,
                body: `You have new order #${orderID} needs to be delivered to the client.`,
                sound: 'default'
            },
            data: {
                click_action: "FLUTTER_NOTIFICATION_CLICK",
                error: "null",
                userType: 'agent',
                id: `${orderID}`,
                message: message
            }
        };

        try {
            await admin.messaging().sendToDevice(tokens, payload_elhariry);
            console.log('Notification sent successfully');
        } catch (err) {
            console.log(err);
        }
    });