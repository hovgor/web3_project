import { ApiProperty } from '@nestjs/swagger';

export class WalletAddressDto {
  @ApiProperty()
  fromAddress: string;

  @ApiProperty()
  toAddress: string;

  @ApiProperty()
  ethBalance: string;
}
