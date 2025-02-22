import { Injectable, Logger } from '@nestjs/common';
import * as firebase from 'firebase-admin';
import {
  Message,
  Notification,
} from 'firebase-admin/lib/messaging/messaging-api';

// eslint-disable-next-line @typescript-eslint/no-var-requires
const firebaseCredentials = require('../../firebase.json');

@Injectable()
export class NotificationsService {
  private logger = new Logger(NotificationsService.name);
  constructor() {
    firebase.initializeApp({
      credential: firebase.credential.cert(firebaseCredentials),
    });
  }

  async sendMessages(notifications: Notification[], token?: string) {
    if (!token) return;
    try {
      const messages: Message[] = notifications.map((notification) => ({
        token,
        notification,
      }));

      await firebase.messaging().sendEach(messages);
    } catch (e) {
      this.logger.error(e);
    }
  }
}
