import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { SensorsService } from 'src/sensors/sensors.service';
import * as argon2 from 'argon2';

@Injectable()
export class SensorGuard implements CanActivate {
  constructor(private readonly sensorService: SensorsService) {}

  async canActivate(
    context: ExecutionContext,
  ): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const sensorSecret = request.headers['x-sensor-secret'];
    const sensorId = request.headers['x-sensor-id'];
    if (!sensorId || !sensorSecret) {
      return false;
    }

    return this.matchRole(request, sensorId, sensorSecret);
  }

  private async matchRole(request: any, sensorId: number, sensorSecret: string) {
    const sensor = await this.sensorService.findOneOrFail(sensorId);
    if (!sensor) {
      return false;
    }
    request.sensor = sensor;

    return await argon2.verify(sensor.secret, sensorSecret);
  }
}
