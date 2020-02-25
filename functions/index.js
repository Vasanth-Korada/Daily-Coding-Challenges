const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

var msgData;
var conceptData;
var articleData;

exports.postsTrigger = functions.firestore.document(
    'Posts/{id}'

).onCreate((snapshot, context) => {
    msgData = snapshot.data();

    return admin.firestore().collection('tokens').get().then((snapshots) => {
        const tokens = [];
        if (snapshots.empty) {
            console.log('No devices');
        } else {
            for (var token of snapshots.docs) {
                tokens.push(token.data().token);
            }
            const payload = {
                "notification": {
                    "title": "New Challenge!",
                    "body": msgData.title,
                    "sound": "default",
                    "icon": "https://image.flaticon.com/icons/png/512/2419/2419224.png",
                },
                "data": {
                    "sendername": msgData.title,
                    "message": msgData.title
                }
            }
            admin.messaging().sendToDevice(tokens, payload).then((response) => {
                console.log('Pushed Notification to all the tokens');
                return null;

            }).catch((err) => {
                console.log(err);
            })
        }
        return null;
    })
})

exports.conceptsTrigger = functions.firestore.document(
    'Concepts/{id}'

).onCreate((snapshot, context) => {
    conceptData = snapshot.data();

    return admin.firestore().collection('tokens').get().then((snapshots) => {
        const tokens = [];
        if (snapshots.empty) {
            console.log('No devices');
        } else {
            for (var token of snapshots.docs) {
                tokens.push(token.data().token);
            }
            const payload = {
                "notification": {
                    "title": "New Concept!",
                    "body": conceptData.title+" in "+conceptData.lang,
                    "sound": "default",
                    "icon": "https://image.flaticon.com/icons/png/512/2419/2419224.png",
                },
                "data": {
                    "sendername": conceptData.title,
                    "message": conceptData.title
                }
            }
            admin.messaging().sendToDevice(tokens, payload).then((response) => {
                console.log('Pushed Notification to all the tokens');
                return null;

            }).catch((err) => {
                console.log(err);
            })
        }
        return null;
    })
})

exports.articlesTrigger = functions.firestore.document(
    'Articles/{id}'

).onCreate((snapshot, context) => {
    articleData = snapshot.data();

    return admin.firestore().collection('tokens').get().then((snapshots) => {
        const tokens = [];
        if (snapshots.empty) {
            console.log('No devices');
        } else {
            for (var token of snapshots.docs) {
                tokens.push(token.data().token);
            }
            const payload = {
                "notification": {
                    "title": "New Article!",
                    "body": articleData.title,
                    "sound": "default",
                    "icon": "https://image.flaticon.com/icons/png/512/2419/2419224.png",
                },
                "data": {
                    "sendername": articleData.title,
                    "message": articleData.title
                }
            }
            admin.messaging().sendToDevice(tokens, payload).then((response) => {
                console.log('Pushed Notification to all the tokens');
                return null;

            }).catch((err) => {
                console.log(err);
            })
        }
        return null;
    })
})