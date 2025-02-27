import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();

/**
 * CPA Grip Postback Listener
 */
export const cpaPostback = functions.https.onRequest(async (req, res): Promise<void> => {
    try {
        // ✅ CPA Grip sends data in the request body, not as query parameters
        const { subid, offer_id, status, payout } = req.body;

        if (!subid || !offer_id || !status) {
            console.warn("⚠️ Missing required parameters", { subid, offer_id, status });
            res.status(400).send("Missing required parameters");
            return;
        }

        // ✅ Ensure payout is a valid number
        const payoutAmount = payout ? parseFloat(payout) * 10 : 0;

        if (status === "completed") {
            await db.collection("completed_offers").add({
                deviceId: subid,
                offerId: offer_id,
                payout: payoutAmount,
                timestamp: admin.firestore.FieldValue.serverTimestamp(),
            });

            console.log(`✅ Offer ${offer_id} completed for device ${subid} with payout $${payoutAmount}`);
        } else {
            console.log(`ℹ️ Offer ${offer_id} has status: ${status}`);
        }

        res.status(200).send("Postback received successfully");
    } catch (error) {
        console.error("❌ Error processing postback:", error);
        res.status(500).send("Server error");
    }
});
