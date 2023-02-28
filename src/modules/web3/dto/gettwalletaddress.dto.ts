import { ApiProperty } from '@nestjs/swagger';

export class GetWalletAddressDto {
  @ApiProperty()
  privateKey: string;
}
