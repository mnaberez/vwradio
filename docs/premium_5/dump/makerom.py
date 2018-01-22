import os
import random

# Sample #2 unknown version
ffs = ['0163', '02C3', '02E6', '02E7', '0302', '0821', '09BE', '09D8', '0AA4', '0B22', '0B27', '0B51', '0EF6', '1313', '1431', '148B', '15F3', '15F6', '1749', '17ED', '1B7D', '1BE2', '1C26', '1C59', '1DFC', '2017', '20F4', '210B', '211A', '221F', '2759', '275A', '28AC', '2974', '2995', '29AC', '29FC', '2A38', '2CFB', '30DB', '311F', '3193', '320F', '36EA', '3908', '3981', '3BD2', '3D21', '3ED3', '3ED8', '4255', '42A2', '42A4', '43AD', '4645', '484B', '49D5', '4A01', '4A08', '4AAA', '4AD6', '4ADD', '4B7E', '4BCD', '4C20', '4C4C', '4C53', '4C72', '4CAA', '4CD9', '4CE2', '4E1C', '51AB', '5617', '5628', '56A5', '5746', '5772', '597A', '59E6', '59E7', '5A9C', '5B3B', '5C82', '5CB5', '5D67', '5D7D', '6223', '6228', '62F7', '6300', '630E', '6335', '6339', '6348', '67BF', '67D5', '67D7', '6842', '699B', '6A25', '6A27', '6A32', '6A5F', '6A61', '6A7D', '6A84', '6A9F', '6AB1', '6AB8', '6ABF', '6ACD', '6AF6', '6B05', '6B09', '6B10', '6B19', '6B22', '6B2B', '6B34', '6B3F', '6B49', '6B6C', '6B7D', '6B93', '6BA0', '6BF1', '6BFF', '6C16', '6C2F', '6C45', '6C5E', '6C83', '6C8F', '6DAD', '6DF8', '6E3B', '6EA9', '7037', '7047', '707E', '70A2', '7106', '712B', '7130', '7155', '7177', '7180', '71A8', '71B1', '71C7', '71D0', '71EE', '71FD', '721F', '7221', '7236', '7244', '7246', '7252', '7260', '7262', '726A', '7297', '72E4', '72EF', '7306', '7310', '734C', '7357', '738A', '73A6', '73D5', '73DE', '73E0', '73E4', '73FB', '743D', '7442', '744D', '748E', '7493', '749E', '74C6', '74CB', '74D9', '74EA', '7536', '7580', '75D4', '75EC', '7601', '7621', '7639', '764E', '76BB', '76C6', '79B2', '7B61', '7C5E', '7D6D', '7DDD', '7E1E', '7F05', '7F6F', '80F4', '884D', '89B2', '89B5', '90B0', '90B3', '98DC', '9BEE', 'A041', 'A044', 'A187', 'A1D5', 'A1D8', 'A3FE', 'A4F4', 'A5A0', 'A618', 'A63F', 'A659', 'A84D', 'A85C', 'A8BC', 'A8CC', 'A9B9', 'A9EA', 'AA3C', 'AB70', 'ABA1', 'ABAA', 'ABE2', 'ABE3', 'ACAE', 'ACB1', 'ACB7', 'ACBA', 'AD2F', 'AD32', 'AE2B', 'AE2E', 'AE99', 'AEAA', 'AEBB', 'AEF5', 'AEF6', 'AEF8', 'AEFF', 'AF02', 'AF05', 'AF0B', 'AF0E', 'AF1A', 'AF8C', 'AFAB', 'AFFF', 'B000', 'B03D', 'B06F', 'B0E8', 'B103', 'B106', 'B109', 'B10C', 'B10F', 'B136', 'B13C', 'B13F', 'B148', 'B14B', 'B14E', 'B154', 'B157', 'B15A', 'B15D', 'B160', 'B163', 'B166', 'B169', 'B16C', 'B1B8', 'B1BA', 'B1C2', 'B25D', 'B28B', 'B293', 'B29A', 'B29B', 'B29D', 'B29F', 'B2A0', 'B2A5', 'B2C2', 'B2F1', 'B302', 'B3A9', 'B3AA', 'B3AB', 'B3B7', 'B3D1', 'B47C', 'B497', 'B498', 'B499', 'B49A', 'B49B', 'B49C', 'B49D', 'B49E', 'B4C7', 'B4C8', 'B4C9', 'B4CB', 'B4CC', 'B4CE', 'B4CF', 'B502', 'B503', 'B504', 'B505', 'B509', 'B50A', 'B5B7', 'B5BA', 'B5BD', 'B66C', 'B66F', 'B670', 'B671', 'B672', 'B675', 'B676', 'B679', 'B67A', 'B6A7', 'B6AA', 'B6AD', 'B6FF', 'B705', 'B71A', 'B71D', 'B720', 'B723', 'B726', 'B83C', 'B866', 'B869', 'B90E', 'B914', 'B983', 'B9FD', 'BAB9', 'BB56', 'BB58', 'BB5A', 'BB69', 'BB6B', 'BBEC', 'BBEE', 'BBF0', 'BBFF', 'BC01', 'BC7A', 'BC7B', 'BCF1', 'BCF8', 'BCFF', 'BD0D', 'BD12', 'BD1E', 'BD20', 'BD2A', 'BD33', 'BD57', 'BDE0', 'BEA9', 'BEE3', 'BFA3', 'BFD1', 'C062', 'C064', 'C066', 'C068', 'C06A', 'C06C', 'C06E', 'C070', 'C072', 'C074', 'C076', 'C078', 'C07A', 'C07C', 'C07E', 'C080', 'C082', 'C084', 'C086', 'C088', 'C08A', 'C08C', 'C08E', 'C090', 'C092', 'C094', 'C096', 'C098', 'C09A', 'C157', 'C179', 'C1B4', 'C1E2', 'C25D', 'C25F', 'C261', 'C263', 'C265', 'C267', 'C269', 'C26B', 'C75C', 'C75E', 'C760', 'C762', 'C764', 'C766', 'C768', 'C76A', 'C76C', 'C797', 'C799', 'C79B', 'C79D', 'C79F', 'C7A1', 'C7A3', 'C7A5', 'C7A7', 'C7A9', 'C7AB', 'C7AD', 'C7AF', 'C8B4', 'C8B6', 'C8B8', 'C8BA', 'C8BC', 'C8BE', 'C8C0', 'C8C2', 'C8C4', 'C8C6', 'C8C8', 'C8CA', 'C8D4', 'CF62', 'CFD2', 'D066', 'D069', 'D06C', 'D075', 'D078', 'D07B', 'D07E', 'D081', 'D087', 'D08A', 'D0B2', 'D0ED', 'D0F1', 'D0F5', 'D136', 'D13A', 'D230', 'D257', 'D38A', 'D414', 'D476', 'D573', 'D587', 'D59B', 'D685', 'D6DA', 'D72E', 'D782', 'D7DC', 'D813', 'D995', 'D9A5', 'D9C1', 'DA2D', 'DA32', 'DAAA', 'DBCB', 'DC32']

ffs = [int(s, 16) for s in ffs]

# make a test image of random data but with 0xFF's in the right places
data = bytearray()
for i in range(0xf000):
    if i in ffs:
        x = 0xFF
    else:
        x = random.randrange(255)
    data.append(x)

patch = {
      0xb3a9: [0x13, 0x24, 0x00],   # mov pm4, #0
      0xb497: [0x71, 0x0B, 0x25],   # clr1 pm5.0
      0xb49a: [0x0A, 0x05],         # set1 p5.0     loop
      0xb49c: [0x87,],              # mov a, [hl]
      0xb49d: [0xF2, 0x04],         # mov p4, a
      0xb4c7: [0x0B, 0x05],         # clr1 p5.0
      0xb4c9: [0x86,],              # incw hl
      0xb502: [0x9B, 0x9a, 0xb4],   # br !loop
      }

# prefill patch area with NOPs to cover gaps between instructions
start = min(patch.keys())
end = max(patch.keys()) + len(patch[max(patch.keys())])
for address in range(start, end):
    data[address] = 0 # nop

# fill area before the patch with a NOP slide
for address in range(0, start):
    data[address] = 0 # nop

# write the patch
for address_base, patch_bytes in patch.items():
    for i, x in enumerate(patch_bytes):
        address = address_base + i
        data[address] = x

# fill area after the patch with 0xFF
for address in range(end, 0xf000):
    data[address] = 0xff

with open('rom.bin', 'wb') as f:
    f.write(data)

os.system('srec_cat rom.bin -binary -o rom.hex -intel -address-length=2 -line-length=44 -crlf')
