import { ApiProperty } from '@nestjs/swagger';

export class ToFixedNumberDto {
  @ApiProperty()
  num?: number;
}
