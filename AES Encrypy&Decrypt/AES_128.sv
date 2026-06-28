module AES(plain_text_128, cipher_key_128, cipher_text_128, flag);


//--------------------------------------
// --------------------inputs-----------
//--------------------------------------
input logic[127:0] plain_text_128;
input logic[127:0] cipher_key_128;
input logic flag;
//---------------------------------
//------------output---------------
//---------------------------------
output logic[127:0] cipher_text_128;
//-------------------------------

logic [127:0] encrypted_128,decrypted_128;



AES_Encrypt a(plain_text_128,cipher_key_128,encrypted_128);

AES_Decrypt a2(encrypted_128,cipher_key_128,decrypted_128);


assign cipher_text_128= (flag) ? encrypted_128 : decrypted_128;


endmodule