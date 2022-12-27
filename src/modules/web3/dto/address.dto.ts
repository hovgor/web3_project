import { ApiProperty } from '@nestjs/swagger';

export class AddressDto {
  @ApiProperty()
  address: string;
}
