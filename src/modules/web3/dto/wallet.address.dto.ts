import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class WalletAddressDto {
  @ApiPropertyOptional()
  privateKey?: string;

  @ApiProperty()
  fromAddress: string;

  @ApiProperty()
  toAddress: string;

  @ApiProperty()
  ethBalance: string;
}
