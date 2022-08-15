------ CÂU L?NH UPDATE
------ 2.33 C?p nh?t l?i giá tr? tr??ng NGAYCHUYENHANG c?a nh?ng b?n ghi có NGAYCHUYENHANG ch?a xác ??nh (NULL)
----trong b?ng ?ONATHANG b?ng v?i giá tr? c?a tr??ng NGAYDATHANG.

--UPDATE DONDATHANG
--SET NGAYCHUYENHANG = NGAYDATHANG
--WHERE NGAYCHUYENHANG IS NULL

------ 2.34 T?ng s? l??ng hàng c?a nh?ng m?t hàng do công ty  VINAMILK cung c?p lên g?p ?ôi

--UPDATE MATHANG
--SET SOLUONG = SOLUONG*2
--FROM NHACUNGCAP
--WHERE MATHANG.MACONGTY = NHACUNGCAP.MACONGTY AND TENCONGTY = 'vinamilk'

----2.35 C?p nh?t giá tr? c?a tr??ng  NOIGIAOHANG trong b?ng DONDATHANG b?ng ??a ch? c?a khách hàng ??i v?i 
----nh?ng ??n ??t hàng ch?a xác ??nh ???c n?i giao hàng (giá tr? tr??ng NOIGIAOHANG b?ng NULL)

--UPDATE DONDATHANG
--SET NOIGIAOHANG = DIACHI
--FROM KHACHHANG 
--WHERE DONDATHANG.MAKHACHHANG = KHACHHANG.MAKHACHHANG AND NOIGIAOHANG IS NULL

----2.36 C?p nh?t l?i d? li?u trong b?ng KHACHHANG sao cho n?u tên công ty và tên giao dich c?a khách hàng 
----trùng v?i tên công ty và tên giao d?ch c?a m?t nhà cung c?p nào ?ó thì ??a ch?, ?i?n tho?i, fax và email 
----ph?i gi?ng nhau

--UPDATE KHACHHANG
--SET KHACHHANG.DIACHI = NHACUNGCAP.DIACHI
--	KHACHHANG.DIENTHOAI = NHACUNGCAP.DIENTHOAI
--	KHACHHANG.FAX = NHACUNGCAP.FAX
--	KHACHHANG.EMAIL = NHACUNGCAP.EMAIL
--FROM NHACUNGCAP
--WHERE KHACHHANG.TENCONGTY = NHACUNGCAP.TENCONGTY AND
--	KHACHHANG.TENGIAODICH = NHACUNGCAP.TENGIAODICH

----2.37 T?ng l??ng lên g?p r??i cho nh?ng nhân viên bán ???c s? l??ng hàng nhi?u h?n 100 trong n?m 2003

--UPDATE NHANVIEN
--SET LUONGCOBAN = LUONGCOBAN*1.5
--WHERE MANHANVIEN = (SELECT MANHANVIEN
--					FROM DONDATHANG INNER JOIN CHITIETDATHANG 
--					ON DONDATHANG.SOHOADON = CHITIETDATHANG.SOHOADON
--					GROUP BY MANHANVIEN
--					HAVING SUM(SOLUONG) > 100)

----2.38 T?ng ph? c?p lên b?ng 50% l??ng cho nh?ng nhân viên bán ???c hàng nhi?u nh?t

--UPDATE NHANVIEN
--SET PHUCAP = LUONGCOBAN * 0.5
--WHERE MANHANVIEN IN 
--(
--SELECT MANHANVIEN
--FROM DONDATHANG INNER JOIN CHITIETDATHANG 
--ON DONDATHANG.SOHOADON = CHITIETDATHANG.SOHOADON
--GROUP BY MANHANVIEN
--HAVING SUM(SOLUONG) >= ALL
--(SELECT SUM(SOLUONG)
--FROM DONDATHANG INNER JOIN CHITIETDATHANG 
--ON DONDATHANG.SOHOADON = CHITIETDATHANG.SOHOADON
--GROUP BY MANHANVIEN
--))


----2.39 gi?m 25% l??ng c?a nh?ng nhân viên trong n?m 2003 không l?p ???c b?t k? ??n ??t hàng nào,

--UPDATE NHANVIEN
--SET LUONGCOBAN =LUONGCOBAN*0.75
--FROM DONDATHANG
--WHERE NHANVIEN.MANHANVIEN = DONDATHANG.MANHANVIEN AND DONDATHANG.SOHOADON IS NULL AND YEAR(NGAYDATHANG) = 2003

--UPDATE NHANVIEN
--SET LUONGCOBAN = LUONGCOBAN*0.75
--WHERE NOT EXISTS 
--(
--SELECT MANHANVIEN
--FROM DONDATHANG
--WHERE MANHANVIEN = NHANVIEN.MANHANVIEN
--)


----2.40 gi? s? trong b?ng DONDATHANG có thêm tr??ng SOTIEN cho bi?t s? ti?n mà khách hàng ph?i tr? 
----trong m?i ??n ??t hàng. Hãy tính giá tr? cho tr??ng này

--UPDATE DONDATHANG
--SET SOTIEN = 
--(
--SELECT SUM(SOLUONG* GIABAN - SOLUONG*GIABAN*MUCGIAMGIA/100)
--FROM CHITIETDATHANG
--WHERE CHITIETDATHANG.SOHOADON = DONDATHANG.SOHOADON
--GROUP BY SOHOADON
--)

----TH?C HI?N CÁC YÊU C?U D??I ?ÂY B?NG CÂU L?NH DELETE

----2.41 Xóa kh?i NHANVIEN nh?ng nhân viên ?ã làm vi?c trong công ty quá 40 n?m

--DELETE FROM NHANVIEN
--WHERE DATEDIFF(YY,NGAYLAMVIEC, GETDATE()) > 40

----2.42 Xóa nh?ng ??n ??t hàng tr??c n?m 2000 ra kh?i c? s? d? li?u

--DELETE FROM DONDATHANG
--WHERE NGAYDATHANG < '1/1/2000'

----2.43 Xóa kh?i b?ng LOAIHANG nh?ng loai hàng hi?n không có m?t hàng

--DELETE FROM LOAIHANG
--WHERE NOT EXISTS 
--(
--SELECT MAHANG 
--FROM MATHANG 
--WHERE MATHANG.MALOAIHANG = LOAIHANG.MALOAIHANG
--)

----2.44 Xóa kh?i b?ng KHACHHANG nh?ng khách hàng hi?n không có b?t k? ??n ??t hàng nào cho công ty
--?A ?A, T?I SAO?? NGHIÊN C?U L?I CÂU NÀY


--DELETE FROM KHACHHANG
--WHERE NOT EXISTS 
--(
--SELECT DONDATHANG.SOHOADON
--FROM DONDATHANG
--WHERE KHACHHANG.MAKHACHHANG = DONDATHANG.MAKHACHHANG
--)
----2.45 xóa kh?i b?ng MATHANG nh?ng m?t hàng có s? l??ng b?ng 0 và không ???c ??t mua trong b?t k? ??n ??t hàng nào.

--DELETE FROM MATHANG
--WHERE SOLUONG = 0 AND NOT EXISTS 
--(
--SELECT SOHOADON
--FROM CHITIETDATHANG
--WHERE CHITIETDATHANG.MAHANG = MATHANG.MAHANG
--)