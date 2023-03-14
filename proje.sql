-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Dec 24, 2022 at 05:23 PM
-- Server version: 5.7.34
-- PHP Version: 7.4.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `proje`
--
CREATE DATABASE IF NOT EXISTS `proje` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `proje`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `1- adı_A_ile_baslayan_musterinin_siparis_bilgileri`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `1- adı_A_ile_baslayan_musterinin_siparis_bilgileri` ()  SELECT 
musteri.musteri_ad , 
siparis.urun_id , 
siparis.siparis_adeti ,
siparis.kargo_no
FROM
musteri,
siparis,
urun,
kargo
WHERE
siparis.musteri_id = musteri.musteri_id
AND
siparis.urun_id = urun.urun_id
AND
siparis.kargo_no = kargo.kargo_no AND
musteri.musteri_ad LIKE 'A%'$$

DROP PROCEDURE IF EXISTS `2-ekran_kartı`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `2-ekran_kartı` ()  SELECT urun.urun_ad,marka.marka_adi ,
urun_ozellik.ekran_kartı
FROM
urun,
marka,
model,
urun_ozellik
WHERE
urun.urun_id = urun_ozellik.urun_id
AND
urun.model_no = model.model_no AND
marka.marka_id = model.marka_id AND
urun_ozellik.ekran_kartı LIKE 'NVIDIA RTX%'$$

DROP PROCEDURE IF EXISTS `3-urun_arama`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `3-urun_arama` (IN `urun` VARCHAR(40))  SELECT 
urun.urun_ad ,
marka.marka_adi AS marka_adı ,
model.model_adi AS model_adı,
urun.urun_fiyat
FROM
urun,
marka,
model
WHERE
urun.model_no = model.model_no
AND
model.marka_id = marka.marka_id AND
urun.urun_ad LIKE CONCAT('%',urun,'%')$$

DROP PROCEDURE IF EXISTS `4-her_bir_personelin_ilgilendigi_toplam_siparis`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `4-her_bir_personelin_ilgilendigi_toplam_siparis` ()  SELECT 
personel.personel_ad,
COUNT(siparis.siparis_no) AS toplam_siparis
FROM 
personel,
siparis
WHERE
siparis.personel_id = personel.personel_id
GROUP BY personel.personel_ad
ORDER BY toplam_siparis$$

DROP PROCEDURE IF EXISTS `5-musteri_id_siparis_bilgisi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `5-musteri_id_siparis_bilgisi` (IN `musteri` INT(11))  SELECT 
musteri.musteri_ad , 
musteri.musteri_soyad ,
siparis.urun_id , 
siparis.siparis_adeti ,
siparis.kargo_no
FROM
musteri,
siparis,
urun,
kargo
WHERE
siparis.musteri_id = musteri.musteri_id
AND
siparis.urun_id = urun.urun_id
AND
siparis.kargo_no = kargo.kargo_no AND
musteri.musteri_id LIKE musteri$$

DROP PROCEDURE IF EXISTS `6-kargo_ismine_gore_siparis`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `6-kargo_ismine_gore_siparis` (IN `kargo` VARCHAR(40))  SELECT kargo.kargo_sirketi AS kargo_adı ,
siparis.siparis_no , urun.urun_ad , model.model_adi , marka.marka_adi
FROM 
kargo , siparis , urun , model , marka
WHERE
siparis.kargo_no = kargo.kargo_no 
AND
siparis.urun_id = urun.urun_id
AND
model.marka_id = marka.marka_id
AND 
urun.model_no = model.model_no
AND
kargo.kargo_sirketi LIKE CONCAT('%',kargo,'%')$$

DROP PROCEDURE IF EXISTS `7-kac_musteri_oyun_bilgisayarı_almıs`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `7-kac_musteri_oyun_bilgisayarı_almıs` ()  SELECT urun.urun_ad , COUNT(musteri.musteri_id) AS toplam_musteri
FROM
musteri,
urun,
siparis
WHERE
siparis.musteri_id = musteri.musteri_id
AND
siparis.urun_id = urun.urun_id
AND
urun.urun_ad LIKE "Dizustu Oyun Bilgisayarı"
GROUP BY urun.urun_ad
ORDER BY toplam_musteri$$

DROP PROCEDURE IF EXISTS `8-girilen_il_musteri_siparis`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `8-girilen_il_musteri_siparis` (IN `il` VARCHAR(40))  SELECT siparis.siparis_no ,
siparis.musteri_id ,
siparis.urun_id ,
siparis.siparis_adeti ,
siparis.kargo_no,
musteri.musteri_il
FROM
siparis,
musteri
WHERE
siparis.musteri_id = musteri.musteri_id AND
musteri.musteri_il IN ('%',il,'%')$$

DROP PROCEDURE IF EXISTS `9-fiyatı_30.000'den_buyuk_urunler`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `9-fiyatı_30.000'den_buyuk_urunler` ()  SELECT  
urun.urun_ad,
marka.marka_adi,
model.model_adi,
urun.urun_fiyat AS fiyat
FROM
urun,
model,
marka
WHERE 
model.model_no = urun.model_no
AND
model.marka_id = marka.marka_id
GROUP BY fiyat,model.model_adi,urun.urun_ad,marka.marka_adi
HAVING urun.urun_fiyat > 30.000$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `eski_fiyat`
--
-- Creation: Dec 23, 2022 at 07:18 PM
--

DROP TABLE IF EXISTS `eski_fiyat`;
CREATE TABLE `eski_fiyat` (
  `urun_id` int(11) NOT NULL,
  `urun_ad` varchar(40) NOT NULL,
  `urun_fiyat` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `eski_fiyat`
--

INSERT INTO `eski_fiyat` (`urun_id`, `urun_ad`, `urun_fiyat`) VALUES
(9, 'Ogrenci Dizustu Bilgisayarı', 22.885);

-- --------------------------------------------------------

--
-- Table structure for table `kargo`
--
-- Creation: Dec 23, 2022 at 07:18 PM
-- Last update: Dec 24, 2022 at 02:16 PM
--

DROP TABLE IF EXISTS `kargo`;
CREATE TABLE `kargo` (
  `kargo_no` int(11) NOT NULL,
  `kargo_sirketi` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `kargo`
--

INSERT INTO `kargo` (`kargo_no`, `kargo_sirketi`) VALUES
(1, 'MNG Kargo'),
(2, 'Aras Kargo'),
(3, 'Surat Kargo'),
(4, 'Yurtici Kargo'),
(5, 'PTT Kargo'),
(6, 'UPS Kargo'),
(7, 'Git  Kargo'),
(8, 'Ay Kargo'),
(9, 'Iyi Kargo'),
(10, 'Vatan Kargo');

-- --------------------------------------------------------

--
-- Table structure for table `marka`
--
-- Creation: Dec 23, 2022 at 07:18 PM
--

DROP TABLE IF EXISTS `marka`;
CREATE TABLE `marka` (
  `marka_id` int(11) NOT NULL,
  `marka_adi` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `marka`
--

INSERT INTO `marka` (`marka_id`, `marka_adi`) VALUES
(1, 'Acer'),
(2, 'Asus'),
(3, 'Apple'),
(4, 'Casper'),
(5, 'Dell'),
(6, 'HP'),
(7, 'Honor'),
(8, 'Huawei'),
(9, 'Lenovo'),
(10, 'MSI');

-- --------------------------------------------------------

--
-- Table structure for table `model`
--
-- Creation: Dec 23, 2022 at 07:18 PM
--

DROP TABLE IF EXISTS `model`;
CREATE TABLE `model` (
  `model_no` int(11) NOT NULL,
  `model_adi` varchar(40) DEFAULT NULL,
  `marka_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `model`
--

INSERT INTO `model` (`model_no`, `model_adi`, `marka_id`) VALUES
(1, 'Nitro 5', 1),
(2, 'TUF Gaming A15', 2),
(3, 'M2 Macbook Air', 3),
(4, 'Nirvana C600', 4),
(5, 'Latitude350', 5),
(6, 'Omen 16-K0001NT', 6),
(7, 'MagicBook 16', 7),
(8, 'Matebook Pro', 8),
(9, 'Chromebook 14e', 9),
(10, 'Vector GP16', 10);

-- --------------------------------------------------------

--
-- Table structure for table `musteri`
--
-- Creation: Dec 23, 2022 at 07:18 PM
-- Last update: Dec 24, 2022 at 04:36 PM
--

DROP TABLE IF EXISTS `musteri`;
CREATE TABLE `musteri` (
  `musteri_id` int(11) NOT NULL,
  `musteri_ad` varchar(40) NOT NULL,
  `musteri_soyad` varchar(40) DEFAULT NULL,
  `TC_kimlik_NO` varchar(11) NOT NULL,
  `musteri_telefon` varchar(11) DEFAULT NULL,
  `musteri_email` varchar(30) NOT NULL,
  `musteri_il` varchar(30) DEFAULT NULL,
  `musteri_ilce` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `musteri`
--

INSERT INTO `musteri` (`musteri_id`, `musteri_ad`, `musteri_soyad`, `TC_kimlik_NO`, `musteri_telefon`, `musteri_email`, `musteri_il`, `musteri_ilce`) VALUES
(1, 'Arda', 'Koca', '56680684306', '05432189012', 'ardal23@hotmail.com', 'Mugla', 'Merkez'),
(2, 'Selda', 'Arslaner', '70400161076', '05432126789', 'seldarsIn@hotmail.com', 'Antalya', 'Alanya'),
(3, 'Orkan', 'Uslubas', '45405385666', '05123567890', 'orhnuslubs@gmail.com', 'Ankara', 'Cankaya'),
(4, 'Abdurrahman', 'Saygin', '22323259132', '05462178906', 'sygn@gmail.com', 'Izmır', 'Balcova'),
(5, 'Emirhan', 'Kalender', '85954694864', '05678943212', 'emrhn33@hotmail.com', 'Adana', 'Seyhan'),
(6, 'Esin', 'Demirdag', '66167568746', '05678912334', 'esindmr21@gmail.com', 'Izmir', 'Gaziemir'),
(7, 'Funda', 'Ozlem', '83343255306', '05769803421', 'fundaozIm128@gmail.com', 'Ankara', 'Golbası'),
(8, 'Seyhan', 'Yanardag', '74260968462', '05541237689', 'syhnynd@hotmail.com', 'Mugla', 'Marmaris'),
(9, 'Songul', 'Yenidunya', '95215829348', '05327658902', 'sngIdnya009@gmail.com', 'Canakkale', 'Biga'),
(10, 'Omer', 'Akova', '88713435234', '05639076591', 'omerakvo765@hotmail.com', 'Istanbul', 'Beyoglu');

--
-- Triggers `musteri`
--
DROP TRIGGER IF EXISTS `3-yeni_eklenen_musteri`;
DELIMITER $$
CREATE TRIGGER `3-yeni_eklenen_musteri` AFTER INSERT ON `musteri` FOR EACH ROW INSERT INTO yeni_eklenen_musteri 
VALUES(
    new.musteri_id,
    new.musteri_ad,
    new.musteri_soyad,
    new.TC_kimlik_NO,
    now()
)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `personel`
--
-- Creation: Dec 23, 2022 at 07:18 PM
-- Last update: Dec 24, 2022 at 04:53 PM
--

DROP TABLE IF EXISTS `personel`;
CREATE TABLE `personel` (
  `personel_id` int(11) NOT NULL,
  `personel_ad` varchar(30) NOT NULL,
  `personel_soyad` varchar(30) DEFAULT NULL,
  `personel_Tc_no` varchar(11) NOT NULL,
  `personel_telefon` varchar(11) DEFAULT NULL,
  `personel_adres` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `personel`
--

INSERT INTO `personel` (`personel_id`, `personel_ad`, `personel_soyad`, `personel_Tc_no`, `personel_telefon`, `personel_adres`) VALUES
(1, 'Yıldırım', 'Faydacı', '58933496940', '05769803421', 'Edirne'),
(2, 'Melisa', 'Ergul', '20706038602', '05335467890', 'Denizli'),
(3, 'Tunga', 'Gedik', '56783163234', '05621906787', 'Sanlıurfa'),
(4, 'Ceylan', 'Menekse', '92244077016', '05621906787', 'Istanbul'),
(5, 'Veli', 'Caglar', '89042885486', '05789012345', 'Sivas'),
(6, 'Sehmus', 'Ilgun', '30676241896', '05367891245', 'Bitlis'),
(7, 'Tevfik', 'Ozgun', '46691016272', '05327896054', 'Corum'),
(8, 'Gonca', 'Kalelioglu', '67317927024', '05398283784', 'Erzurum'),
(9, 'Nesrin', 'Dinc', '16289598626', '05123467890', 'Sakarya'),
(10, 'Omur', 'Senturk', '90244354786', '05897643245', 'Eskisehir');

--
-- Triggers `personel`
--
DROP TRIGGER IF EXISTS `1-personel_silme`;
DELIMITER $$
CREATE TRIGGER `1-personel_silme` AFTER DELETE ON `personel` FOR EACH ROW INSERT INTO silinen_personel 
VALUES(old.personel_id,old.personel_ad,now())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `silinen_personel`
--
-- Creation: Dec 23, 2022 at 07:18 PM
--

DROP TABLE IF EXISTS `silinen_personel`;
CREATE TABLE `silinen_personel` (
  `personel_id` int(11) NOT NULL,
  `personel_ad` varchar(30) NOT NULL,
  `silinme_tarihi` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `silinen_personel`
--

INSERT INTO `silinen_personel` (`personel_id`, `personel_ad`, `silinme_tarihi`) VALUES
(10, 'Omur', '2022-12-14 17:37:48'),
(8, 'Gonca', '2022-12-14 17:37:55');

-- --------------------------------------------------------

--
-- Table structure for table `siparis`
--
-- Creation: Dec 23, 2022 at 07:18 PM
--

DROP TABLE IF EXISTS `siparis`;
CREATE TABLE `siparis` (
  `siparis_no` int(11) NOT NULL,
  `musteri_id` int(11) DEFAULT NULL,
  `urun_id` int(11) DEFAULT NULL,
  `personel_id` int(11) DEFAULT NULL,
  `siparis_adeti` int(11) NOT NULL,
  `kargo_no` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `siparis`
--

INSERT INTO `siparis` (`siparis_no`, `musteri_id`, `urun_id`, `personel_id`, `siparis_adeti`, `kargo_no`) VALUES
(1, 2, 3, 3, 1, 3),
(2, 2, 10, 5, 2, 4),
(3, 1, 2, 7, 3, 1),
(4, 3, 5, 3, 2, 6),
(5, 4, 3, 6, 4, 1),
(6, 1, 10, 7, 5, 3),
(7, 5, 5, 9, 3, 7),
(8, 9, 2, 9, 1, 6),
(9, 4, 7, 5, 6, 2),
(10, 6, 9, 1, 2, 5);

-- --------------------------------------------------------

--
-- Table structure for table `urun`
--
-- Creation: Dec 23, 2022 at 07:18 PM
--

DROP TABLE IF EXISTS `urun`;
CREATE TABLE `urun` (
  `urun_id` int(11) NOT NULL,
  `urun_ad` varchar(40) NOT NULL,
  `model_no` int(11) NOT NULL,
  `urun_fiyat` float DEFAULT NULL,
  `urun_stok` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `urun`
--

INSERT INTO `urun` (`urun_id`, `urun_ad`, `model_no`, `urun_fiyat`, `urun_stok`) VALUES
(1, 'Dizustu Oyun Bilgisayarı', 1, 18.999, '1'),
(2, 'Dizustu Oyun Bilgisayarı', 2, 28.799, '56'),
(3, 'Ev ve Ogrenci Bilgisayarı', 3, 29.999, '97'),
(4, 'Dizustu Is Bilgisayarı', 4, 13.211, '200'),
(5, 'Dizustu Is Bilgisayarı', 5, 19.999, '225'),
(6, 'Dizustu Oyun Bilgisayarı', 6, 43.799, '300'),
(7, 'Ev ve Ogrenci Bilgisayarı', 7, 16.599, '144'),
(8, 'Ev ve Ogrenci Bilgisayarı', 8, 44.999, '350'),
(9, 'Ogrenci Dizustu Bilgisayarı', 9, 23.485, '1'),
(10, 'Dizustu Oyun Bilgisayarı', 10, 58.997, '390');

--
-- Triggers `urun`
--
DROP TRIGGER IF EXISTS `2-fiyat_guncelleme`;
DELIMITER $$
CREATE TRIGGER `2-fiyat_guncelleme` BEFORE UPDATE ON `urun` FOR EACH ROW INSERT INTO eski_fiyat
VALUES
(old.urun_id,
 old.urun_ad,
 old.urun_fiyat)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `urun_ozellik`
--
-- Creation: Dec 23, 2022 at 07:18 PM
--

DROP TABLE IF EXISTS `urun_ozellik`;
CREATE TABLE `urun_ozellik` (
  `urun_id` int(11) DEFAULT NULL,
  `ekran_kartı` varchar(40) NOT NULL,
  `islemci_marka` varchar(40) NOT NULL,
  `islemci_ozellik` varchar(40) DEFAULT NULL,
  `ram` varchar(40) DEFAULT NULL,
  `sabit_disk` varchar(30) DEFAULT NULL,
  `isletim_sistemi` varchar(30) DEFAULT NULL,
  `ekran_ozellik` varchar(15) DEFAULT NULL,
  `kullanım_amacı` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `urun_ozellik`
--

INSERT INTO `urun_ozellik` (`urun_id`, `ekran_kartı`, `islemci_marka`, `islemci_ozellik`, `ram`, `sabit_disk`, `isletim_sistemi`, `ekran_ozellik`, `kullanım_amacı`) VALUES
(1, 'NVIDIA RTX3050', 'IntelCore', 'i5 10300H', '8GB', '512GB SSD', 'FreeDos', '15.6Inc', 'Oyun'),
(2, 'NVIDIA RTX3060', 'AMD Ryzen7', '6800H', '16GB', '512GB SSD', 'FreeDos', '15.6Inc', 'Oyun'),
(3, 'Yok', 'Apple', 'M2 8 Cekirdek', '8GB', '256GB SSD', 'MacOS', '13.6Inc Retina', 'Is ve Ogrenci'),
(4, 'IntelIrıs Exe', 'IntelCore', 'i7-1165G7', '8GB', '512GB SSD', 'FreeDos', '15.6Inc', 'Ofis ve Is'),
(5, 'UHD Graphics', 'IntelCore', 'i5-8265U', '4GB', '1TB SSD', 'Linux', '15.6Inc', 'Ofis ve Is'),
(6, 'NVIDIA RTX3060 TI', 'IntelCore', 'i7-12700H', '16GB', '512GB SSD', 'Windows11', '15.6Inc', 'Oyun'),
(7, 'AMD Radeon Graphics', 'AMD Ryzen5', '5600H', '16GB', '512GB SSD', 'Windows11', '15.6Inc', 'Ogrenci ve Ofis'),
(8, 'NVIDIA Geforce 250MX', 'IntelCore', 'i7-10510U', '16GB', '1TB SSD', 'Windows10', '13.9Inc', 'Is ve Ogrenci'),
(9, 'UHD Graphics', 'Intel Celeron', 'N4020', '4GB', '64GB', 'ChromeOS', '11.6Inc', 'Ogrenci'),
(10, 'NVIDIA RTX3080', 'Intel Core', 'i7-12700H', '32GB', '1TB SSD', 'Freedos', '17.3Inc', 'Oyun');

-- --------------------------------------------------------

--
-- Table structure for table `yeni_eklenen_musteri`
--
-- Creation: Dec 23, 2022 at 07:18 PM
--

DROP TABLE IF EXISTS `yeni_eklenen_musteri`;
CREATE TABLE `yeni_eklenen_musteri` (
  `musteri_id` int(11) NOT NULL,
  `musteri_ad` varchar(40) NOT NULL,
  `musteri_soyad` varchar(40) DEFAULT NULL,
  `TC_kimlik_NO` varchar(11) DEFAULT NULL,
  `eklenme_tarihi` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `yeni_eklenen_musteri`
--

INSERT INTO `yeni_eklenen_musteri` (`musteri_id`, `musteri_ad`, `musteri_soyad`, `TC_kimlik_NO`, `eklenme_tarihi`) VALUES
(11, 'Ahmet', 'Kaya', '85545755936', '2022-12-14 21:32:08'),
(12, 'GÖKNUR ', 'BİLGİHAN', '51487059616', '2022-12-14 21:35:14');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `kargo`
--
ALTER TABLE `kargo`
  ADD PRIMARY KEY (`kargo_no`);

--
-- Indexes for table `marka`
--
ALTER TABLE `marka`
  ADD PRIMARY KEY (`marka_id`);

--
-- Indexes for table `model`
--
ALTER TABLE `model`
  ADD PRIMARY KEY (`model_no`),
  ADD KEY `fk_model_marka` (`marka_id`);

--
-- Indexes for table `musteri`
--
ALTER TABLE `musteri`
  ADD PRIMARY KEY (`musteri_id`),
  ADD UNIQUE KEY `TC_kimlik_NO` (`TC_kimlik_NO`),
  ADD UNIQUE KEY `musteri_email` (`musteri_email`);

--
-- Indexes for table `personel`
--
ALTER TABLE `personel`
  ADD PRIMARY KEY (`personel_id`),
  ADD UNIQUE KEY `personel_Tc_no` (`personel_Tc_no`);

--
-- Indexes for table `siparis`
--
ALTER TABLE `siparis`
  ADD PRIMARY KEY (`siparis_no`),
  ADD KEY `fk_siparis_musteri` (`musteri_id`),
  ADD KEY `fk_siparis_urun` (`urun_id`),
  ADD KEY `fk_siparis_kargo` (`kargo_no`),
  ADD KEY `fk_siparis_personel` (`personel_id`);

--
-- Indexes for table `urun`
--
ALTER TABLE `urun`
  ADD PRIMARY KEY (`urun_id`),
  ADD KEY `fk_urun_model` (`model_no`);

--
-- Indexes for table `urun_ozellik`
--
ALTER TABLE `urun_ozellik`
  ADD KEY `fk_urun_urun_ozellk` (`urun_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `model`
--
ALTER TABLE `model`
  ADD CONSTRAINT `fk_model_marka` FOREIGN KEY (`marka_id`) REFERENCES `marka` (`marka_id`);

--
-- Constraints for table `siparis`
--
ALTER TABLE `siparis`
  ADD CONSTRAINT `fk_siparis_kargo` FOREIGN KEY (`kargo_no`) REFERENCES `kargo` (`kargo_no`),
  ADD CONSTRAINT `fk_siparis_musteri` FOREIGN KEY (`musteri_id`) REFERENCES `musteri` (`musteri_id`),
  ADD CONSTRAINT `fk_siparis_personel` FOREIGN KEY (`personel_id`) REFERENCES `personel` (`personel_id`),
  ADD CONSTRAINT `fk_siparis_urun` FOREIGN KEY (`urun_id`) REFERENCES `urun` (`urun_id`);

--
-- Constraints for table `urun`
--
ALTER TABLE `urun`
  ADD CONSTRAINT `fk_urun_model` FOREIGN KEY (`model_no`) REFERENCES `model` (`model_no`);

--
-- Constraints for table `urun_ozellik`
--
ALTER TABLE `urun_ozellik`
  ADD CONSTRAINT `fk_urun_urun_ozellk` FOREIGN KEY (`urun_id`) REFERENCES `urun` (`urun_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
