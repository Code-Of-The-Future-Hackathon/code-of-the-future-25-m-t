import { Injectable } from '@nestjs/common';
import { z } from 'zod';
import OpenAI from 'openai';
import { zodResponseFormat } from 'openai/helpers/zod';
import { CostEstimateType } from 'src/issues/types';
import { TypeEntity } from 'src/categories/entities';

@Injectable()
export class AiService {
  private readonly openaiApiKey = process.env.OPENAI_API_KEY;
  private readonly openai = new OpenAI({ apiKey: this.openaiApiKey });

  private readonly responseSchema = z.object({
    items: z.array(
      z.object({
        shortIssueName: z.string(),
        materialsCost: z.number(),
        laborCost: z.number(),
      }),
    ),
  });

  async estimateCost(
    description: string,
    type: TypeEntity,
  ): Promise<CostEstimateType[]> {
    const completion = await this.openai.beta.chat.completions.parse({
      model: 'gpt-4o-mini-2024-07-18',
      messages: [
        {
          role: 'system',
          content: `I am a city official in Bulgaria. I want you to compile a list of FIVE potential causes for this type of issue based on the report of citizens based on types: ${type.category.title} - ${type.title}. For each potential cause provide an estimate of the cost of materials and labor to fix the issue. The cost should be in Bulgarian leva. Make sure that shortIssueName is a user-friendly name for the issue in Bulgarian.`,
        },
        {
          role: 'user',
          content: description ?? '',
        },
      ],
      response_format: zodResponseFormat(this.responseSchema, 'causes'),
    });

    const items = completion.choices[0].message.parsed.items.map((item) => ({
      ...item,
      totalCost: item.materialsCost + item.laborCost,
      currency: 'BGN',
    }));

    return items as CostEstimateType[];
  }
}
