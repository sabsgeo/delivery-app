import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const mainFunction = functions.firestore.document('user_orders/{orderId}').onUpdate(async snapshot => {
  const order:any = snapshot.after.data();
  const querySnap = await db.collection('user_info').doc(order.user).collection('tokens').get();
  const userInfo:any = await db.collection('user_info').doc(order.user).get();
  let titleText = '';
  let bodyText = '';
  if (order.order_status.split('.')[1] === 'AWAITING_CONFORMATION') {
    titleText = 'Awaiting conformation';
    bodyText = `Hello ${userInfo.data().firstName}, We are checking all the items you ordered`;
  } else if (order.order_status.split('.')[1] === 'ORDER_ACCEPTED') {
    titleText = 'Order accepted'
    bodyText = `Hello ${userInfo.data().firstName}, We are collecting all the items you ordered`
  } else if (order.order_status.split('.')[1] === 'ORDER_DECLINED') {
    titleText = 'Order declined'
    bodyText = `Hello ${userInfo.data().firstName}, We are sorry that we had to cancel the order`
  } else if (order.order_status.split('.')[1] === 'ORDER_ON_THE_WAY') {
    titleText = 'Order on the way'
    bodyText = `Hello ${userInfo.data().firstName}, Our delivery executive is on the way`
  } else if (order.order_status.split('.')[1] === 'ORDER_DELIVERED') {
    titleText = 'Order delivered'
    bodyText = `Hello ${userInfo.data().firstName}, Your order is successfully delivered. So rate the order. Seen you soon`
  } else if (order.order_status.split('.')[1] === 'ORDER_CANCELLED') {
    titleText = 'Order cancelled'
    bodyText = `Hello ${userInfo.data().firstName}, You have cancelled the order. Hope we could serve you soon`
  }

  const tokens: any[] = querySnap.docs.map(snap => snap.data().type === 'notification' ? snap.id:null).filter(n => n);
  const payload: admin.messaging.MessagingPayload = {
    notification: {
      title: titleText,
      body: bodyText,
    },
    data: {
      click_action: "FLUTTER_NOTIFICATION_CLICK",
      sound: 'default',
      status: 'done',
      screen: 'home',
      orderStatus: order.order_status,
      orderId: snapshot.after.id
    },
  }
  return fcm.sendToDevice(tokens, payload);
});