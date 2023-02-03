import { ApiProperty } from '@nestjs/swagger';

export class HashingSistemDto {
  @ApiProperty()
  codeForHashing: string;
}
