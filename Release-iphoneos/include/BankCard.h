//�ӿ� �жϵ�ǰͼ��ĶԽ���ֵ�������Ƿ���е���ʶ��
//һ����Ϊ����ֵ����5.0f���Խ���ʶ��
#ifdef __cplusplus
extern "C"
#endif
float GetFocusScore(unsigned char *imgdata, int width, int height, int pitch, int lft, int top, int rgt, int btm);

//�ӿ�
//����ImageFormat.NV21ֱ������ʶ�𣬲�����java���ת����������߹���Ч��, java��ת��̫���� Android
#ifdef __cplusplus
extern "C"
#endif
int BankCardNV21(unsigned char *pbResult, int nMaxSize, unsigned char *pbNV21, int iW, int iH, int iLft, int iTop, int iRgt, int iBtm);

//�ӿ�
//����ImageFormat.NV12ֱ������ʶ��  IOS
#ifdef __cplusplus
extern "C"
#endif
int BankCardNV12(unsigned char *pbResult, int nMaxSize, unsigned char *pbNV12, int iW, int iH, int iLft, int iTop, int iRgt, int iBtm);


//�ӿڣ�һ�����ֻ��ϵ�������ӿ�
//����32λ��ͼ��ת��24λ��ͼ��Androidϵͳ��
#ifdef __cplusplus
extern "C"
#endif
int BankCard32(unsigned char *pbResult, int nMaxSize, unsigned char *pbImg32, int iW, int iH, int iPitch);

