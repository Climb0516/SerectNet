# SerectNet
接口加密请求




加密方式：：：：：：
 *  签名值（sign）为所有必传参数除去（sign）之外按照键值升序排列，将其值拼接为字符串计算其MD5，然后在其后加上一个公共SKEY再计算MD5后获取。
 *  例如：某个接口除了必传参数之外，还需要传递a、b、c和d这4个参数，那么sign值的计算方式如下：
 *  sign = md5(md5(a+b+c+channel+d+loc+key+net+timestamp)+SKEY)
 *  SKEY值根据不同版本会有所不用，当前版本SKEY：【TczAFlw@SyhYEyh*】
 *  注意：部分接口无需计算签名，均有标示，此时sign可以为任意非空字符串。
