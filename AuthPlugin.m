#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>

static NSString * const kKeyActiveCode = @"ActiveAuthCode";
static NSString * const kKeyActiveDevice = @"ActiveAuthDevice";
static NSString * const kKeyActivationTime = @"ActiveAuthTime";
static NSString * const kKeyCodeType = @"ActiveCodeType";

static NSArray *getAuthDatabase() {
    static NSArray *database = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        database = @[
            // ===== 樱境物语 日卡 (100) =====
            @{@"code": @"DAY-077K2-EMP89", @"type": @"日卡"}, @{@"code": @"DAY-12HD3-ITY6G", @"type": @"日卡"}, @{@"code": @"DAY-16YL4-ZZQRW", @"type": @"日卡"}, @{@"code": @"DAY-1EC8X-WI0VO", @"type": @"日卡"}, @{@"code": @"DAY-1QGC6-QHNYC", @"type": @"日卡"}, @{@"code": @"DAY-1RCTZ-225MD", @"type": @"日卡"}, @{@"code": @"DAY-1Z5J8-ISIAI", @"type": @"日卡"}, @{@"code": @"DAY-2IHM5-2T0RJ", @"type": @"日卡"}, @{@"code": @"DAY-2IVXF-0NDII", @"type": @"日卡"}, @{@"code": @"DAY-2VRUJ-TDH3F", @"type": @"日卡"},
            @{@"code": @"DAY-3144W-X77B0", @"type": @"日卡"}, @{@"code": @"DAY-37IM3-USTC2", @"type": @"日卡"}, @{@"code": @"DAY-385C5-MG6M7", @"type": @"日卡"}, @{@"code": @"DAY-3T1WW-SGFY7", @"type": @"日卡"}, @{@"code": @"DAY-42NV7-IFZID", @"type": @"日卡"}, @{@"code": @"DAY-4A6H0-6KCAE", @"type": @"日卡"}, @{@"code": @"DAY-4KYQK-8K650", @"type": @"日卡"}, @{@"code": @"DAY-4RXYN-XV9MT", @"type": @"日卡"}, @{@"code": @"DAY-4VA3S-Y35JR", @"type": @"日卡"}, @{@"code": @"DAY-5I3N3-OOURM", @"type": @"日卡"},
            @{@"code": @"DAY-6IOD0-WHOQ8", @"type": @"日卡"}, @{@"code": @"DAY-6IOQ0-LVRG9", @"type": @"日卡"}, @{@"code": @"DAY-6M3J3-FKHPR", @"type": @"日卡"}, @{@"code": @"DAY-6RFPD-1KRE9", @"type": @"日卡"}, @{@"code": @"DAY-79CSY-SCRUS", @"type": @"日卡"}, @{@"code": @"DAY-7DVKK-YVSR1", @"type": @"日卡"}, @{@"code": @"DAY-8S6IL-LHKNT", @"type": @"日卡"}, @{@"code": @"DAY-8U4YI-KQC8A", @"type": @"日卡"}, @{@"code": @"DAY-92KYC-B8GR8", @"type": @"日卡"}, @{@"code": @"DAY-9GJN1-LCUNQ", @"type": @"日卡"},
            @{@"code": @"DAY-9MX2B-O4G2W", @"type": @"日卡"}, @{@"code": @"DAY-9NDHC-RDKBM", @"type": @"日卡"}, @{@"code": @"DAY-A5CW2-E1K5U", @"type": @"日卡"}, @{@"code": @"DAY-AELKU-3X4N5", @"type": @"日卡"}, @{@"code": @"DAY-BDB9J-SH0KJ", @"type": @"日卡"}, @{@"code": @"DAY-BPLGK-YSMS4", @"type": @"日卡"}, @{@"code": @"DAY-BV5AF-O28O8", @"type": @"日卡"}, @{@"code": @"DAY-CMFVD-QKW7L", @"type": @"日卡"}, @{@"code": @"DAY-CVEM0-EWOXA", @"type": @"日卡"}, @{@"code": @"DAY-CWNOM-WFKLN", @"type": @"日卡"},
            @{@"code": @"DAY-CXQYT-72XIK", @"type": @"日卡"}, @{@"code": @"DAY-D08D7-ANTXN", @"type": @"日卡"}, @{@"code": @"DAY-DBRCJ-T1VCZ", @"type": @"日卡"}, @{@"code": @"DAY-DMC65-H2L51", @"type": @"日卡"}, @{@"code": @"DAY-DOQ9X-HBQY1", @"type": @"日卡"}, @{@"code": @"DAY-EGZ0I-L8VAO", @"type": @"日卡"}, @{@"code": @"DAY-EZ3OF-OYHNI", @"type": @"日卡"}, @{@"code": @"DAY-EZDMY-ACXT3", @"type": @"日卡"}, @{@"code": @"DAY-FB1L1-FFH4P", @"type": @"日卡"}, @{@"code": @"DAY-FFX2D-2MLDX", @"type": @"日卡"},
            @{@"code": @"DAY-FI2E1-UX26A", @"type": @"日卡"}, @{@"code": @"DAY-FTMFD-XNMCB", @"type": @"日卡"}, @{@"code": @"DAY-GO9V9-0BYAX", @"type": @"日卡"}, @{@"code": @"DAY-GOCMK-85TYT", @"type": @"日卡"}, @{@"code": @"DAY-GRRE7-TUE50", @"type": @"日卡"}, @{@"code": @"DAY-GRXB7-ZDYZZ", @"type": @"日卡"}, @{@"code": @"DAY-GZE9Q-MCSUG", @"type": @"日卡"}, @{@"code": @"DAY-HB7LS-Z3Y31", @"type": @"日卡"}, @{@"code": @"DAY-HMEHZ-LX28E", @"type": @"日卡"}, @{@"code": @"DAY-IL95C-XAZVC", @"type": @"日卡"},
            @{@"code": @"DAY-J8KDE-YBI6C", @"type": @"日卡"}, @{@"code": @"DAY-JUMZS-23SJ5", @"type": @"日卡"}, @{@"code": @"DAY-KCPOA-QMHA2", @"type": @"日卡"}, @{@"code": @"DAY-L8DK6-VUL3H", @"type": @"日卡"}, @{@"code": @"DAY-LEZ1L-B7UA3", @"type": @"日卡"}, @{@"code": @"DAY-LH2E9-V4N7K", @"type": @"日卡"}, @{@"code": @"DAY-M2H4D-NFP6I", @"type": @"日卡"}, @{@"code": @"DAY-N03KO-9C3FK", @"type": @"日卡"}, @{@"code": @"DAY-NKJM8-VZ9CJ", @"type": @"日卡"}, @{@"code": @"DAY-OP7CU-SWE1I", @"type": @"日卡"},
            @{@"code": @"DAY-PTVVJ-Y0DOZ", @"type": @"日卡"}, @{@"code": @"DAY-QEE8E-MK474", @"type": @"日卡"}, @{@"code": @"DAY-QUGJI-XO0JQ", @"type": @"日卡"}, @{@"code": @"DAY-R2877-RBYSW", @"type": @"日卡"}, @{@"code": @"DAY-R34E9-X5V54", @"type": @"日卡"}, @{@"code": @"DAY-RPB7W-C509M", @"type": @"日卡"}, @{@"code": @"DAY-RXKBX-11444", @"type": @"日卡"}, @{@"code": @"DAY-RZI1H-0OD40", @"type": @"日卡"}, @{@"code": @"DAY-S6XX3-VWA47", @"type": @"日卡"}, @{@"code": @"DAY-SROFW-C96CI", @"type": @"日卡"},
            @{@"code": @"DAY-TTFP2-JN7W1", @"type": @"日卡"}, @{@"code": @"DAY-TUB3P-O68YP", @"type": @"日卡"}, @{@"code": @"DAY-UIK5N-T65FY", @"type": @"日卡"}, @{@"code": @"DAY-UKBAV-X2ED3", @"type": @"日卡"}, @{@"code": @"DAY-UZ4KK-II2QO", @"type": @"日卡"}, @{@"code": @"DAY-VG88U-0JXQ9", @"type": @"日卡"}, @{@"code": @"DAY-VOWTY-YIN67", @"type": @"日卡"}, @{@"code": @"DAY-VRNEI-NQTMM", @"type": @"日卡"}, @{@"code": @"DAY-VWDC5-087SG", @"type": @"日卡"}, @{@"code": @"DAY-W9S4Q-4K8TL", @"type": @"日卡"},
            @{@"code": @"DAY-WA9HK-1XF55", @"type": @"日卡"}, @{@"code": @"DAY-WGV5Z-8DQ94", @"type": @"日卡"}, @{@"code": @"DAY-WJNZV-B4Z49", @"type": @"日卡"}, @{@"code": @"DAY-X3QBE-1BZJR", @"type": @"日卡"}, @{@"code": @"DAY-X8I24-GXTG0", @"type": @"日卡"}, @{@"code": @"DAY-X8Q2J-VLAAH", @"type": @"日卡"}, @{@"code": @"DAY-XMN46-UFOML", @"type": @"日卡"}, @{@"code": @"DAY-XT0ZJ-56P5L", @"type": @"日卡"}, @{@"code": @"DAY-YVAHO-CW4LE", @"type": @"日卡"}, @{@"code": @"DAY-ZO3EH-0RW3L", @"type": @"日卡"},

            // ===== 樱境物语 月卡 (100) =====
            @{@"code": @"MON-034H9-WF1AH", @"type": @"月卡"}, @{@"code": @"MON-0JK69-EYBA7", @"type": @"月卡"}, @{@"code": @"MON-1DWPL-5MG5F", @"type": @"月卡"}, @{@"code": @"MON-21JBS-48H39", @"type": @"月卡"}, @{@"code": @"MON-25GBR-QDPYK", @"type": @"月卡"}, @{@"code": @"MON-26SV7-GLVE4", @"type": @"月卡"}, @{@"code": @"MON-29X4L-W8P6U", @"type": @"月卡"}, @{@"code": @"MON-2Q00Y-VNDEL", @"type": @"月卡"}, @{@"code": @"MON-2WR3F-IFTA7", @"type": @"月卡"}, @{@"code": @"MON-3E637-7YCV7", @"type": @"月卡"},
            @{@"code": @"MON-3MZDP-8DXPZ", @"type": @"月卡"}, @{@"code": @"MON-3W6PB-JDW1V", @"type": @"月卡"}, @{@"code": @"MON-3WKSX-R1VEK", @"type": @"月卡"}, @{@"code": @"MON-4KURN-Z106T", @"type": @"月卡"}, @{@"code": @"MON-4O1R4-L4WY7", @"type": @"月卡"}, @{@"code": @"MON-5UBRQ-REDUU", @"type": @"月卡"}, @{@"code": @"MON-656YP-UYD55", @"type": @"月卡"}, @{@"code": @"MON-6GUXC-MQWSK", @"type": @"月卡"}, @{@"code": @"MON-6ZMVR-52P2C", @"type": @"月卡"}, @{@"code": @"MON-759MB-HS2O1", @"type": @"月卡"},
            @{@"code": @"MON-78RVB-832ON", @"type": @"月卡"}, @{@"code": @"MON-7XBNB-VJ1RV", @"type": @"月卡"}, @{@"code": @"MON-8220V-J70M9", @"type": @"月卡"}, @{@"code": @"MON-8BOJP-GQ6ZS", @"type": @"月卡"}, @{@"code": @"MON-8K469-VMVWH", @"type": @"月卡"}, @{@"code": @"MON-90BJT-Z0FA7", @"type": @"月卡"}, @{@"code": @"MON-9D1TO-YM7ZJ", @"type": @"月卡"}, @{@"code": @"MON-9QTG0-H0NXZ", @"type": @"月卡"}, @{@"code": @"MON-A92H8-DOLQ6", @"type": @"月卡"}, @{@"code": @"MON-ABCDB-OKB5N", @"type": @"月卡"},
            @{@"code": @"MON-ABHNS-2W7C7", @"type": @"月卡"}, @{@"code": @"MON-AL2ZU-G1JZU", @"type": @"月卡"}, @{@"code": @"MON-AMDEJ-22A8C", @"type": @"月卡"}, @{@"code": @"MON-ATHHD-5V12B", @"type": @"月卡"}, @{@"code": @"MON-AZUJJ-J27EX", @"type": @"月卡"}, @{@"code": @"MON-B27QZ-8LJW7", @"type": @"月卡"}, @{@"code": @"MON-BDJG5-P2TZF", @"type": @"月卡"}, @{@"code": @"MON-BVTIJ-MV2H1", @"type": @"月卡"}, @{@"code": @"MON-CF3RG-K0NQO", @"type": @"月卡"}, @{@"code": @"MON-CVUYO-TUH8V", @"type": @"月卡"},
            @{@"code": @"MON-DAKP4-SJQLS", @"type": @"月卡"}, @{@"code": @"MON-DC91O-RKV17", @"type": @"月卡"}, @{@"code": @"MON-DSHZK-M0Z66", @"type": @"月卡"}, @{@"code": @"MON-F3R4Z-80QQN", @"type": @"月卡"}, @{@"code": @"MON-F4VF3-S46YU", @"type": @"月卡"}, @{@"code": @"MON-FBKEY-REIBV", @"type": @"月卡"}, @{@"code": @"MON-FJO5L-YQPE5", @"type": @"月卡"}, @{@"code": @"MON-FYVYV-QZ01G", @"type": @"月卡"}, @{@"code": @"MON-GAJ5E-DSMEO", @"type": @"月卡"}, @{@"code": @"MON-HPKML-GRCD3", @"type": @"月卡"},
            @{@"code": @"MON-I5K7P-D0585", @"type": @"月卡"}, @{@"code": @"MON-IBUPT-QS32L", @"type": @"月卡"}, @{@"code": @"MON-INFB8-WINLP", @"type": @"月卡"}, @{@"code": @"MON-J2SI2-MK3TU", @"type": @"月卡"}, @{@"code": @"MON-JSN68-PT4VB", @"type": @"月卡"}, @{@"code": @"MON-JTYGN-Q3NW8", @"type": @"月卡"}, @{@"code": @"MON-K1Z7A-4T1P8", @"type": @"月卡"}, @{@"code": @"MON-K740E-NOGT4", @"type": @"月卡"}, @{@"code": @"MON-KB433-HWWJC", @"type": @"月卡"}, @{@"code": @"MON-KDUUA-BECJ4", @"type": @"月卡"},
            @{@"code": @"MON-KGBCW-ZD8KA", @"type": @"月卡"}, @{@"code": @"MON-KNSAU-09JD2", @"type": @"月卡"}, @{@"code": @"MON-LNYK6-Y02NQ", @"type": @"月卡"}, @{@"code": @"MON-LVCDH-4DLIT", @"type": @"月卡"}, @{@"code": @"MON-LZQFP-UAPXA", @"type": @"月卡"}, @{@"code": @"MON-M2UT5-74LWE", @"type": @"月卡"}, @{@"code": @"MON-M80AF-4318Q", @"type": @"月卡"}, @{@"code": @"MON-MSSV2-Z7YEB", @"type": @"月卡"}, @{@"code": @"MON-NAJAN-P9ZM9", @"type": @"月卡"}, @{@"code": @"MON-NHXSO-6GEOC", @"type": @"月卡"},
            @{@"code": @"MON-NVHR2-PCJ96", @"type": @"月卡"}, @{@"code": @"MON-PIWRW-7QFMX", @"type": @"月卡"}, @{@"code": @"MON-Q8P0J-URNH2", @"type": @"月卡"}, @{@"code": @"MON-QA2VI-XTWU7", @"type": @"月卡"}, @{@"code": @"MON-QOKZJ-CU9GL", @"type": @"月卡"}, @{@"code": @"MON-QYE2H-U19UX", @"type": @"月卡"}, @{@"code": @"MON-QZ0XA-ODKER", @"type": @"月卡"}, @{@"code": @"MON-R5S3Y-ZUF97", @"type": @"月卡"}, @{@"code": @"MON-RGEFU-B4YZC", @"type": @"月卡"}, @{@"code": @"MON-RJRRD-1GLVC", @"type": @"月卡"},
            @{@"code": @"MON-RQARN-TH2TF", @"type": @"月卡"}, @{@"code": @"MON-RYZLZ-3TI4U", @"type": @"月卡"}, @{@"code": @"MON-S7EB6-ZVATH", @"type": @"月卡"}, @{@"code": @"MON-SPYJ9-5SUM2", @"type": @"月卡"}, @{@"code": @"MON-T192B-HWB5H", @"type": @"月卡"}, @{@"code": @"MON-UGQLP-12Y05", @"type": @"月卡"}, @{@"code": @"MON-W7CBH-7Y6PA", @"type": @"月卡"}, @{@"code": @"MON-WFLZZ-C0G7C", @"type": @"月卡"}, @{@"code": @"MON-WT45Z-YIERH", @"type": @"月卡"}, @{@"code": @"MON-XD4YR-6IAO8", @"type": @"月卡"},
            @{@"code": @"MON-XMRW0-8JW5N", @"type": @"月卡"}, @{@"code": @"MON-XV0FM-4ZSN0", @"type": @"月卡"}, @{@"code": @"MON-XY0XE-U2VKF", @"type": @"月卡"}, @{@"code": @"MON-YC8ER-U77X2", @"type": @"月卡"}, @{@"code": @"MON-YSRCO-B063E", @"type": @"月卡"}, @{@"code": @"MON-YWPUS-K4OYU", @"type": @"月卡"}, @{@"code": @"MON-Z3C04-2BFMJ", @"type": @"月卡"}, @{@"code": @"MON-Z5VRO-NWRKF", @"type": @"月卡"}, @{@"code": @"MON-ZESB6-X3MVX", @"type": @"月卡"}, @{@"code": @"MON-ZZA8M-LQ9Z7", @"type": @"月卡"},

            // ===== 樱境物语 永久卡 (100) =====
            @{@"code": @"PER-080QT-616SN", @"type": @"永久卡"}, @{@"code": @"PER-0AYB8-X88GI", @"type": @"永久卡"}, @{@"code": @"PER-0K5IR-T2WV5", @"type": @"永久卡"}, @{@"code": @"PER-0LL30-WMCG3", @"type": @"永久卡"}, @{@"code": @"PER-0U60L-XSOPZ", @"type": @"永久卡"}, @{@"code": @"PER-10B58-CRV4A", @"type": @"永久卡"}, @{@"code": @"PER-22OGI-IXT5I", @"type": @"永久卡"}, @{@"code": @"PER-23GCZ-HRDYF", @"type": @"永久卡"}, @{@"code": @"PER-2950X-DRDCL", @"type": @"永久卡"}, @{@"code": @"PER-2U6Q9-9E779", @"type": @"永久卡"},
            @{@"code": @"PER-3O4AA-KG74L", @"type": @"永久卡"}, @{@"code": @"PER-3VVJ0-81VUD", @"type": @"永久卡"}, @{@"code": @"PER-43NY3-ACG1R", @"type": @"永久卡"}, @{@"code": @"PER-4WG42-TGJCB", @"type": @"永久卡"}, @{@"code": @"PER-4ZH1D-ZTU10", @"type": @"永久卡"}, @{@"code": @"PER-51D0K-XW8MZ", @"type": @"永久卡"}, @{@"code": @"PER-59IWK-BPL99", @"type": @"永久卡"}, @{@"code": @"PER-5YN8T-9I9IN", @"type": @"永久卡"}, @{@"code": @"PER-6F2CP-PFNK4", @"type": @"永久卡"}, @{@"code": @"PER-6GQUX-48MBT", @"type": @"永久卡"},
            @{@"code": @"PER-6JROG-7WG6B", @"type": @"永久卡"}, @{@"code": @"PER-6NJ3B-ROL0T", @"type": @"永久卡"}, @{@"code": @"PER-6PDQR-KP7RU", @"type": @"永久卡"}, @{@"code": @"PER-6XH0Y-TICMB", @"type": @"永久卡"}, @{@"code": @"PER-6Z1Y3-SI8IE", @"type": @"永久卡"}, @{@"code": @"PER-73TZF-U50KW", @"type": @"永久卡"}, @{@"code": @"PER-7T281-UUIZD", @"type": @"永久卡"}, @{@"code": @"PER-7XR5S-P3KIT", @"type": @"永久卡"}, @{@"code": @"PER-805RQ-QB2SO", @"type": @"永久卡"}, @{@"code": @"PER-8MMC3-AVZXY", @"type": @"永久卡"},
            @{@"code": @"PER-9D01T-BX3AW", @"type": @"永久卡"}, @{@"code": @"PER-9MEJQ-59PV5", @"type": @"永久卡"}, @{@"code": @"PER-9VB98-SE9RF", @"type": @"永久卡"}, @{@"code": @"PER-A2IQP-K92H0", @"type": @"永久卡"}, @{@"code": @"PER-AE85U-TVTDN", @"type": @"永久卡"}, @{@"code": @"PER-APHEO-MDTPO", @"type": @"永久卡"}, @{@"code": @"PER-ARJV1-YQYEB", @"type": @"永久卡"}, @{@"code": @"PER-AXNHC-J7W25", @"type": @"永久卡"}, @{@"code": @"PER-B0PC2-S9IM9", @"type": @"永久卡"}, @{@"code": @"PER-B2Q2Y-BC1ZP", @"type": @"永久卡"},
            @{@"code": @"PER-BA4S6-NU79I", @"type": @"永久卡"}, @{@"code": @"PER-BTC0X-O6SN2", @"type": @"永久卡"}, @{@"code": @"PER-CCJCH-EXHQ8", @"type": @"永久卡"}, @{@"code": @"PER-CZVK5-DZB1Z", @"type": @"永久卡"}, @{@"code": @"PER-DA32E-484L0", @"type": @"永久卡"}, @{@"code": @"PER-DKDAB-SVZND", @"type": @"永久卡"}, @{@"code": @"PER-DQDRI-I914U", @"type": @"永久卡"}, @{@"code": @"PER-DUQKR-V1PGT", @"type": @"永久卡"}, @{@"code": @"PER-EB6T1-UAN5J", @"type": @"永久卡"}, @{@"code": @"PER-EI6YE-7LJOK", @"type": @"永久卡"},
            @{@"code": @"PER-ENN35-PR800", @"type": @"永久卡"}, @{@"code": @"PER-EQMA6-GMHIO", @"type": @"永久卡"}, @{@"code": @"PER-F6C3U-0335D", @"type": @"永久卡"}, @{@"code": @"PER-G5X2G-X8CNB", @"type": @"永久卡"}, @{@"code": @"PER-GB2GY-4QHVB", @"type": @"永久卡"}, @{@"code": @"PER-GP6C5-9A5GC", @"type": @"永久卡"}, @{@"code": @"PER-GT86B-99EXL", @"type": @"永久卡"}, @{@"code": @"PER-HQBQQ-I85H5", @"type": @"永久卡"}, @{@"code": @"PER-HWUM6-P2JQD", @"type": @"永久卡"}, @{@"code": @"PER-I7OQJ-6C9V4", @"type": @"永久卡"},
            @{@"code": @"PER-IL0TM-XYVXC", @"type": @"永久卡"}, @{@"code": @"PER-IQHTS-ZAMZ4", @"type": @"永久卡"}, @{@"code": @"PER-J2JQI-MJN6J", @"type": @"永久卡"}, @{@"code": @"PER-KU3FQ-XPW0X", @"type": @"永久卡"}, @{@"code": @"PER-L5R18-QRK4Z", @"type": @"永久卡"}, @{@"code": @"PER-M1ZRI-SRJWI", @"type": @"永久卡"}, @{@"code": @"PER-MDMXQ-VYNYR", @"type": @"永久卡"}, @{@"code": @"PER-MHZ99-E5VPV", @"type": @"永久卡"}, @{@"code": @"PER-MMZV1-3BJJD", @"type": @"永久卡"}, @{@"code": @"PER-N7F89-GKZFT", @"type": @"永久卡"},
            @{@"code": @"PER-OMOCH-DS68Q", @"type": @"永久卡"}, @{@"code": @"PER-OV6BK-G0988", @"type": @"永久卡"}, @{@"code": @"PER-P2D1C-5ZQMZ", @"type": @"永久卡"}, @{@"code": @"PER-Q29Z2-QIQXP", @"type": @"永久卡"}, @{@"code": @"PER-QFNIB-YSKRN", @"type": @"永久卡"}, @{@"code": @"PER-QIEUO-ETEYS", @"type": @"永久卡"}, @{@"code": @"PER-QVAV7-9MYIN", @"type": @"永久卡"}, @{@"code": @"PER-QWJXQ-4OP5V", @"type": @"永久卡"}, @{@"code": @"PER-R07FH-9RYPM", @"type": @"永久卡"}, @{@"code": @"PER-REE3M-B4Z6Z", @"type": @"永久卡"},
            @{@"code": @"PER-RTSWU-S4RBW", @"type": @"永久卡"}, @{@"code": @"PER-RX9KH-IRAAZ", @"type": @"永久卡"}, @{@"code": @"PER-SB0GC-GXSXL", @"type": @"永久卡"}, @{@"code": @"PER-SFTAV-BW2L4", @"type": @"永久卡"}, @{@"code": @"PER-SYX0K-W79JP", @"type": @"永久卡"}, @{@"code": @"PER-TTUEL-5A2DB", @"type": @"永久卡"}, @{@"code": @"PER-UACQG-MVF81", @"type": @"永久卡"}, @{@"code": @"PER-UXMT8-H9HJ6", @"type": @"永久卡"}, @{@"code": @"PER-UY1QY-2831J", @"type": @"永久卡"}, @{@"code": @"PER-V0KTB-NXTRX", @"type": @"永久卡"},
            @{@"code": @"PER-V25TR-0JVK2", @"type": @"永久卡"}, @{@"code": @"PER-WVMTM-A7VJB", @"type": @"永久卡"}, @{@"code": @"PER-YE6EC-7IIXR", @"type": @"永久卡"}, @{@"code": @"PER-YFYE4-PFFVC", @"type": @"永久卡"}, @{@"code": @"PER-YSIEL-KS1B1", @"type": @"永久卡"}, @{@"code": @"PER-Z1J1B-474B9", @"type": @"永久卡"}, @{@"code": @"PER-ZI68G-L4BLR", @"type": @"永久卡"}, @{@"code": @"PER-ZMJJO-8PROR", @"type": @"永久卡"}, @{@"code": @"PER-ZSJ93-QOUDA", @"type": @"永久卡"}, @{@"code": @"PER-ZTMIY-HDY9L", @"type": @"永久卡"}
        ];
    });
    return database;
}

@interface AuthManager : NSObject
+ (instancetype)sharedInstance;
- (void)checkAndLoad;
@end

@implementation AuthManager
+ (instancetype)sharedInstance {
    static AuthManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ instance = [[AuthManager alloc] init]; });
    return instance;
}
- (void)checkAndLoad {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *activeCode = [defaults objectForKey:kKeyActiveCode];
    NSString *activeDevice = [defaults objectForKey:kKeyActiveDevice];
    NSTimeInterval activationTime = [defaults doubleForKey:kKeyActivationTime];
    NSString *codeType = [defaults objectForKey:kKeyCodeType];
    
    NSString *currentDevice = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    BOOL isValid = NO;
    
    if (activeCode && [activeDevice isEqualToString:currentDevice]) {
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval elapsed = now - activationTime;
        if ([codeType isEqualToString:@"永久卡"]) isValid = YES;
        else if ([codeType isEqualToString:@"日卡"]) isValid = (elapsed < 24 * 3600);
        else if ([codeType isEqualToString:@"月卡"]) isValid = (elapsed < 30 * 24 * 3600);
    }
    
    if (isValid) {
        [self loadTargetDylib];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{ [self showAuthUI]; });
    }
}

- (void)loadTargetDylib {
    // 针对樱境物语：加载 libCherryTale.dylib
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *dylibPath = [bundlePath stringByAppendingPathComponent:@"Frameworks/libCherryTale.dylib"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dylibPath]) { 
        NSLog(@"[Auth] 找不到目标: %@", dylibPath);
        return; 
    }
    dlopen([dylibPath UTF8String], RTLD_NOW);
}

- (void)showAuthUI {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (!rootVC) return;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"授权验证" message:@"请输入您的激活码以启动游戏" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) { textField.placeholder = @"粘贴或输入激活码"; }];
    
    UIAlertAction *activateAction = [UIAlertAction actionWithTitle:@"激活" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { 
        [self verifyCode:alert.textFields.firstObject.text]; 
    }];
    
    UIAlertAction *exitAction = [UIAlertAction actionWithTitle:@"退出游戏" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) { 
        exit(0); 
    }];
    
    [alert addAction:activateAction];
    [alert addAction:exitAction];
    [rootVC presentViewController:alert animated:YES completion:nil];
}

- (void)verifyCode:(NSString *)code {
    NSArray *codesArray = getAuthDatabase();
    BOOL codeFound = NO;
    NSString *cardType = nil;
    NSString *cleanCode = [[code stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    for (NSDictionary *dict in codesArray) {
        if ([dict[@"code"] isEqualToString:cleanCode]) { codeFound = YES; cardType = dict[@"type"]; break; }
    }
    
    if (!codeFound) { 
        [self showErrorAndKill:@"激活码无效，请检查输入"]; 
        return; 
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *savedDevice = [defaults objectForKey:[NSString stringWithFormat:@"Device_%@", cleanCode]];
    NSString *currentDevice = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    if (savedDevice && ![savedDevice isEqualToString:currentDevice]) { 
        [self showErrorAndKill:@"该激活码已在其他设备绑定，无法跨设备使用"]; 
        return; 
    }
    
    [defaults setObject:cleanCode forKey:kKeyActiveCode];
    [defaults setObject:currentDevice forKey:kKeyActiveDevice];
    [defaults setObject:@([[NSDate date] timeIntervalSince1970]) forKey:kKeyActivationTime];
    [defaults setObject:cardType forKey:kKeyCodeType];
    [defaults setObject:currentDevice forKey:[NSString stringWithFormat:@"Device_%@", cleanCode]];
    [defaults synchronize];
    
    [self loadTargetDylib];
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC dismissViewControllerAnimated:YES completion:^{ 
        UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"成功" message:@"授权成功，祝您游戏愉快！" preferredStyle:UIAlertControllerStyleAlert];
        [successAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [rootVC presentViewController:successAlert animated:YES completion:nil];
    }];
}

- (void)showErrorAndKill:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootVC dismissViewControllerAnimated:YES completion:nil]; 
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) { 
            exit(0); 
        }]];
        [rootVC presentViewController:alert animated:YES completion:nil];
    });
}

@end

__attribute__((constructor)) static void initPlugin() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[AuthManager sharedInstance] checkAndLoad];
    });
}
