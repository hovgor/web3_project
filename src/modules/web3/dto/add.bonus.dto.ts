import { ApiProperty } from '@nestjs/swagger';

export class AddBonusDto {
  @ApiProperty()
  username: string;

  @ApiProperty()
  userId: number;
}
