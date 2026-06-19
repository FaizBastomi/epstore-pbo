-- =====================================================================
--  EpStore - Tabel Kupon
--  Sesuai dengan model Kupon.java
-- =====================================================================

USE `epstore`;

DROP TABLE IF EXISTS `kupon`;
CREATE TABLE `kupon` (
    `id`           INT          NOT NULL AUTO_INCREMENT,
    `kodePromo`    VARCHAR(50)  NOT NULL,
    `persenDiskon` DOUBLE       NOT NULL DEFAULT 0.0,
    `expireAt`     DATE         DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_kupon_kodePromo` (`kodePromo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------------------
-- Data dummy kupon
-- ---------------------------------------------------------------------
INSERT INTO `kupon` (`kodePromo`, `persenDiskon`, `expireAt`) VALUES
    ('WELCOME10', 10.0, '2026-12-31'),
    ('SUPER20', 20.0, '2026-12-31'),
    ('MEGA50', 50.0, '2026-06-30');
