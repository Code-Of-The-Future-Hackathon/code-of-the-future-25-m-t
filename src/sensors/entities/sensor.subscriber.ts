import {
  EventSubscriber,
  EntitySubscriberInterface,
  InsertEvent,
  UpdateEvent,
} from 'typeorm';
import * as argon2 from 'argon2';

import { SensorEntity } from './sensor.entity';

@EventSubscriber()
export class SensorSubsciber
  implements EntitySubscriberInterface<SensorEntity>
{
  listenTo() {
    return SensorEntity;
  }

  async beforeInsert(event: InsertEvent<SensorEntity>): Promise<void> {
    await this.hashPassword(event.entity);
  }

  async beforeUpdate(event: UpdateEvent<SensorEntity>): Promise<void> {
    if (
      event?.entity?.secret &&
      event.entity.secret !== event.databaseEntity.secret
    ) {
      await this.hashPassword(event.entity as SensorEntity);
    }
  }

  private async hashPassword(sensor: SensorEntity): Promise<void> {
    if (sensor.secret) {
      sensor.secret = await argon2.hash(sensor.secret);
    }
  }
}
