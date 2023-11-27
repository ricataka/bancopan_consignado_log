
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();
const db = admin.firestore();


// Callable funciton to create a user
exports.updateRebanho = functions.https.onCall(async (data, context) => {
    let uid = data;
    console.log("function was called by user with id  : " + context.auth?.uid || null); // the question mark in typescript is usually used to mark parameter as optiona

        await db
            .collection("participantes")
            .doc(uid)
            .update(
                {
                    isRebanho: true,
                },

            )
            .then(() => {
                console.log("User Created");
                return {
                    "status": "success",
                    "uid": uid
                };
            })
            .catch((err) => {
                console.log("Error updating value : " + err);
                return {
                    "status": "failure",
                    "message": "Update Error"
                };
            });
});
module.exports.updateRebanho = exports.updateRebanho;