import { BadRequestException, Injectable } from '@nestjs/common';
import * as AWS from 'aws-sdk';
import * as dotenv from 'dotenv';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { FileEntity } from './entities';
import { FileErrorCodes } from './errors';

dotenv.config();

@Injectable()
export class FilesService {
  constructor(
    @InjectRepository(FileEntity)
    private readonly fileRepository: Repository<FileEntity>,
  ) {}

  AWS_S3_BUCKET = process.env.AWS_S3_BUCKET;
  s3 = new AWS.S3({
    endpoint: 'https://fra1.digitaloceanspaces.com',
    accessKeyId: process.env.AMAZON_ACCESS_KEY_ID,
    secretAccessKey: process.env.AMAZON_ACCESS_SECRET,
  });

  async uploadFile(
    file?: Express.Multer.File,
    mealId?: number,
    comboMealId?: number,
  ) {
    if (!file) {
      return null;
    }
    const uploadedFile = await this.s3Upload(
      file.buffer,
      this.AWS_S3_BUCKET,
      Date.now() + '_' + file.originalname.replaceAll(' ', '_'),
      file.mimetype,
    );

    return await this.fileRepository.save({
      key: uploadedFile.Key,
      url: uploadedFile.Location,
      ...(mealId ? { meal: { id: mealId } } : {}),
      ...(comboMealId ? { combo: { id: comboMealId } } : {}),
    });
  }

  async uploadFiles(
    files: Array<Express.Multer.File>,
    mealId?: number,
    comboMealId?: number,
  ) {
    return await Promise.all(
      files.map((file) => this.uploadFile(file, mealId, comboMealId)),
    );
  }

  async deleteFile(key: string, bucket: string) {
    const file = await this.findOneByKeyOrFail(key);

    await this.fileRepository.remove(file);

    return await this.s3
      .deleteObject({
        Bucket: bucket,
        Key: key,
      })
      .promise();
  }

  async findOneByKeyOrFail(key: string) {
    const file = await this.fileRepository.findOne({
      where: {
        key,
      },
    });

    if (!file) {
      throw new BadRequestException(FileErrorCodes.FileNotFoundError);
    }

    return file;
  }

  async findOneOrFail(id: number) {
    const file = await this.fileRepository.findOne({
      where: {
        id,
      },
    });

    if (!file) {
      throw new BadRequestException(FileErrorCodes.FileNotFoundError);
    }

    return file;
  }

  async deleteFiles(keys: string[], bucket: string) {
    return await Promise.all(keys.map((key) => this.deleteFile(key, bucket)));
  }

  async s3Upload(
    buffer: Buffer,
    bucket: string,
    name: string,
    mimetype: string,
  ) {
    const params = {
      Bucket: bucket,
      Key: name,
      Body: buffer,
      ACL: 'public-read',
      ContentType: mimetype,
      ContentDisposition: 'inline',
    };

    try {
      return await this.s3.upload(params).promise();
    } catch (e) {
      console.log(e);
    }
  }
}
