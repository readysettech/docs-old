DROP TABLE IF EXISTS `readyset_sample`;

CREATE TABLE `readyset_sample` (
  `id` int(8) unsigned NOT NULL auto_increment,
  `createdOn` varchar(255) default NULL,
  `firstName` varchar(255) default NULL,
  `lastName` varchar(255) default NULL,
  `phone` varchar(100) default NULL,
  `email` varchar(255) default NULL,
  `address` varchar(255) default NULL,
  `postalZip` varchar(255),
  `luckyNumbers` varchar(255) default NULL,
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=1;

INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2021-07-18','Lance','Miles','1-636-748-0428','miles-lance386@icloud.com','Ap #953-9654 Porttitor St.','19665','79, 23'),
  ('2022-09-10','Leroy','Reed','1-415-368-9896','lreed@google.net','Ap #232-9279 Tempus Rd.','18362','3, 17, 61'),
  ('2022-07-13','Deirdre','Conway','1-475-315-1893','d.conway@aol.edu','Ap #140-2745 Ultrices. Street','60002','17, 67, 1, 2, 5, 73'),
  ('2019-12-26','Sigourney','Townsend','(888) 322-2713','s.townsend@hotmail.net','P.O. Box 443, 4524 Morbi Av.','24261','23'),
  ('2021-03-28','Zeus','Mcmahon','(641) 433-3038','z_mcmahon@google.com','P.O. Box 870, 1132 Risus. St.','24663','41, 71, 11, 19'),
  ('2021-09-25','Ramona','Sanchez','(286) 577-7575','sanchez-ramona3949@icloud.ca','945-3919 Cursus, Rd.','75681','37, 31, 3, 71, 11, 41'),
  ('2020-03-17','Raja','Greer','(380) 348-3133','greer-raja1462@icloud.org','Ap #995-5490 Quam Street','16227','73, 19'),
  ('2020-10-14','Cameron','Lloyd','(727) 705-4061','c-lloyd@icloud.edu','Ap #971-8714 Interdum Rd.','85935','1'),
  ('2022-02-09','Alana','Huber','(864) 221-1371','huber.alana1161@outlook.org','430-8216 Euismod Av.','46510','53, 61, 2, 5'),
  ('2021-01-25','Yetta','Dorsey','(323) 451-1548','y.dorsey@hotmail.edu','3713 Sed St.','70369','19, 79, 71');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2021-03-07','Rina','Henry','(241) 748-2354','henryrina2708@outlook.com','P.O. Box 239, 4596 Dolor Rd.','97285','1, 31'),
  ('2020-09-15','Jelani','Simpson','(272) 823-1568','simpson-jelani9784@hotmail.edu','Ap #911-605 Suspendisse Road','55885','5, 7'),
  ('2021-04-12','Aristotle','Jordan','(229) 711-1241','jordan-aristotle7387@aol.com','Ap #926-4243 Et Rd.','30555','43, 83, 79, 47, 7, 37'),
  ('2021-07-28','Moana','Floyd','(344) 389-2128','mfloyd@google.edu','Ap #226-1589 Lorem St.','11795',''),
  ('2020-11-13','Lavinia','Reilly','1-153-642-2586','reilly.lavinia6433@icloud.org','Ap #513-6306 Donec Street','06246','83, 67, 89, 3'),
  ('2020-08-21','Anjolie','Horn','1-933-275-6976','a-horn@outlook.org','P.O. Box 516, 5956 Integer Rd.','89815','3, 7, 23, 1'),
  ('2020-08-16','Lana','Shannon','1-857-418-7211','shannonlana@outlook.edu','894-6867 Quam Road','57371','47, 1'),
  ('2022-04-20','Hanna','Bradley','1-105-950-2817','h_bradley@aol.edu','627-2743 Rutrum Rd.','86142','13'),
  ('2020-08-16','Sybill','David','1-429-625-6217','s_david@icloud.edu','Ap #890-2996 Fusce Street','92114','47, 67'),
  ('2020-10-09','Reuben','Hopkins','(631) 865-4212','hopkins-reuben@yahoo.ca','P.O. Box 684, 1805 Velit Ave','54397','19, 11');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2022-05-22','Wade','Meyer','(425) 635-3168','m_wade@google.edu','Ap #347-1468 Fusce Street','86813','11, 3, 5, 2, 97'),
  ('2020-05-11','Denise','Lancaster','(134) 587-7148','lancaster_denise@aol.ca','Ap #147-3617 Penatibus Rd.','70260','43, 13'),
  ('2021-10-18','Griffith','Lewis','(612) 580-6043','lewis.griffith7038@icloud.net','P.O. Box 671, 7243 Ligula. Ave','74667','23, 29, 53'),
  ('2020-07-19','Benjamin','Pickett','(778) 328-6816','pickett-benjamin@icloud.com','8690 Vel, Road','53880','23, 31, 3, 83'),
  ('2022-05-20','Phillip','English','(633) 481-3671','english_phillip@google.org','Ap #684-8964 Dis Rd.','05763','61'),
  ('2020-01-28','Malik','James','1-681-445-1954','m_james@google.net','989-3970 Feugiat Ave','47743','47, 61, 29, 67'),
  ('2022-07-11','Garth','Carrillo','1-586-525-5419','c.garth2087@yahoo.edu','P.O. Box 243, 4182 Malesuada Ave','16265','11'),
  ('2021-04-27','Margaret','Green','1-837-744-2285','gmargaret@aol.net','P.O. Box 860, 6679 Sem, Rd.','67531','29, 67, 59, 11, 19, 7'),
  ('2022-02-03','Kiayada','Stokes','1-873-151-4102','kiayada.stokes@aol.org','Ap #819-7288 Enim. Av.','27656','2'),
  ('2021-05-05','Lael','Huber','(507) 665-4647','l.huber@hotmail.org','Ap #937-6279 Eget, Street','55426','');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2019-12-15','Akeem','Porter','1-214-686-4359','pakeem@hotmail.ca','Ap #461-323 Nisi. Avenue','96943','89, 13'),
  ('2019-12-28','Irene','Wilkinson','(343) 321-2251','w-irene@google.net','P.O. Box 965, 954 Tincidunt St.','75493','37, 19, 1'),
  ('2020-04-14','Illana','Head','(855) 558-6475','headillana@outlook.ca','808-1757 Tortor. St.','57889','97, 43, 3'),
  ('2021-11-03','Quemby','Houston','(876) 461-1095','houston-quemby4628@icloud.edu','Ap #772-5240 A St.','85344','31, 67, 29, 17'),
  ('2020-03-21','Chester','Bailey','1-537-202-8848','b_chester1009@aol.com','P.O. Box 237, 2844 Nulla Rd.','48157','79, 17, 13'),
  ('2020-02-24','Myra','Henderson','1-327-136-6783','m-henderson@hotmail.edu','7416 Nibh. Road','58215','53, 7, 59'),
  ('2020-09-15','Damian','Odom','1-642-322-5725','odom-damian3942@hotmail.org','P.O. Box 913, 3129 A, Avenue','99512','41, 23, 3, 47, 43, 13'),
  ('2021-02-11','Jameson','Spencer','(230) 723-3153','spencerjameson@outlook.ca','809-2030 Parturient Street','64785','23, 13'),
  ('2020-04-04','Dillon','Perez','(117) 881-0557','d-perez497@yahoo.ca','9201 Mauris Rd.','69158','31, 71, 2, 3, 37, 43'),
  ('2021-01-29','Brenden','Marquez','1-222-463-2799','marquez_brenden2505@aol.ca','5785 Tempor Ave','15283','5, 59, 17');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2021-04-28','Micah','Wilkerson','1-298-884-8139','wilkerson.micah4117@protonmail.com','565-4553 Et Rd.','91390','97, 53, 2'),
  ('2021-08-13','Kibo','Hurst','(347) 670-2418','khurst480@hotmail.org','Ap #362-5990 Est, Rd.','12957','41, 5'),
  ('2021-01-28','Tanisha','Morrow','(165) 658-4461','morrow_tanisha@outlook.com','Ap #911-7459 Nunc Rd.','26056',''),
  ('2020-05-29','Ciaran','Young','1-688-323-2642','c_young1414@icloud.org','1996 Nisi Av.','73344','7, 19, 23, 97'),
  ('2021-10-04','Montana','Dixon','(375) 667-9563','mdixon4840@protonmail.com','Ap #962-122 Mauris Rd.','11787','2, 37'),
  ('2022-08-09','Ivor','Macias','(558) 745-3425','i-macias@aol.net','7672 Nulla St.','05447','7'),
  ('2022-04-29','Talon','Goff','(538) 228-1427','t-goff@outlook.ca','8857 Vel, Av.','51336','11, 23, 47'),
  ('2020-03-18','Luke','Hood','(405) 267-0309','hood_luke@aol.org','734-6523 Adipiscing Road','80107','53, 89, 13, 43, 73, 47'),
  ('2021-06-22','Bruno','Rowland','(784) 744-8073','rowland.bruno5505@icloud.net','7077 Sed St.','53233','23, 1'),
  ('2022-01-16','Lilah','Whitney','(736) 425-6102','l-whitney@icloud.com','638-5546 Consectetuer St.','22732','67, 17, 11, 37, 1, 3');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2020-11-06','Amery','Terrell','(762) 532-7666','a-terrell@aol.net','418-2734 Eu Avenue','78155','17'),
  ('2020-11-20','Linus','Lindsay','1-223-923-5242','linuslindsay@protonmail.edu','537-2564 Ipsum Rd.','15213','19, 23, 53, 17, 59'),
  ('2020-06-23','Ima','Copeland','(781) 672-8221','c_ima@google.com','Ap #416-9666 Consectetuer Street','47370','41'),
  ('2020-03-21','Dustin','Graham','(798) 525-8266','graham.dustin@protonmail.edu','P.O. Box 858, 5336 Quam. Avenue','08740','17'),
  ('2020-12-07','Hiram','Case','1-348-805-1703','casehiram4935@yahoo.net','Ap #850-456 Egestas. Ave','44368','89, 97, 37, 59, 73'),
  ('2021-11-28','Rhona','Love','(678) 389-2412','r-love@icloud.edu','Ap #907-3334 Eros Avenue','25000','79, 3, 19'),
  ('2022-07-21','Autumn','Martin','(621) 239-2782','martin_autumn@outlook.net','Ap #601-4271 Sollicitudin Street','34630','71'),
  ('2020-05-30','Macey','Roberson','(727) 184-4991','m_roberson933@protonmail.net','Ap #580-1817 Tincidunt St.','94021','97, 43, 41'),
  ('2020-12-17','Aspen','Hayden','1-516-825-6638','hayden.aspen@google.edu','P.O. Box 895, 4788 Lorem, Av.','59266','79, 67, 61, 17, 31'),
  ('2021-09-18','Serina','Bradshaw','(441) 874-4724','s.bradshaw4427@google.com','161-3157 Nunc Rd.','46598','97, 59, 47, 11');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2020-02-21','Penelope','Blankenship','1-647-214-6635','penelope-blankenship@google.ca','685-9839 Dolor St.','95795','3'),
  ('2020-03-19','Inga','Cline','(276) 533-2062','ingacline186@outlook.ca','P.O. Box 778, 9465 Et Avenue','11227','41, 3, 5, 29, 13'),
  ('2019-12-02','Jael','Nash','(288) 558-8821','n.jael5101@yahoo.org','908-7545 Suspendisse Rd.','29414','53, 23'),
  ('2022-04-04','Lillith','Mccall','1-207-177-3243','lillith_mccall5970@yahoo.net','P.O. Box 926, 2479 Phasellus Road','25338','37, 1'),
  ('2021-05-24','Ray','Emerson','(727) 751-7316','emerson-ray7047@outlook.ca','897-8542 Mattis St.','53201',''),
  ('2021-11-25','Shoshana','Pollard','1-615-404-4247','shoshanapollard8637@protonmail.com','1151 Nunc Street','33968','89, 29'),
  ('2020-06-17','Brenda','Clayton','(383) 731-3947','c_brenda2691@hotmail.edu','944-3386 Vulputate, Ave','68767','79'),
  ('2019-12-08','Burke','Bartlett','(162) 757-4190','bartlett-burke4937@google.edu','Ap #180-9083 Pharetra. Avenue','38687','2, 23, 73'),
  ('2021-03-04','Odysseus','Monroe','(353) 744-7510','m.odysseus@icloud.ca','Ap #189-4143 Nulla Rd.','63283','31, 79, 61'),
  ('2021-08-08','Fuller','Mccormick','1-855-234-4081','m-fuller@icloud.com','443-7373 Duis St.','23938','67, 7, 11, 41, 79');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2022-01-17','Marshall','Vaughan','(768) 220-1347','m_vaughan929@outlook.net','811-849 Pede. St.','13677','29, 17, 79, 31, 47, 67'),
  ('2020-07-19','Hannah','Pearson','1-116-438-2496','pearson-hannah4212@icloud.com','534-6025 Suspendisse Ave','67463','67'),
  ('2021-10-27','Dara','Webster','1-480-587-3773','dara_webster@hotmail.net','Ap #181-5370 Convallis Rd.','36468',''),
  ('2020-02-14','Veronica','Hoffman','1-277-413-7961','hoffmanveronica760@yahoo.ca','1375 Volutpat. Av.','48896','31, 5, 11, 17, 67'),
  ('2021-10-24','Karina','Noble','1-316-167-9912','karinanoble2822@icloud.edu','Ap #140-5700 Magna Rd.','85841','3, 71, 37, 7, 41, 5'),
  ('2021-11-15','Timon','Hall','(736) 322-5592','hall-timon6021@icloud.edu','Ap #228-8976 Vel St.','01313','13, 17'),
  ('2021-10-15','Frances','Rocha','(683) 322-1343','francesrocha@outlook.edu','P.O. Box 291, 9701 Eget Av.','56298','31, 2, 23'),
  ('2019-12-21','Ferdinand','Hester','1-816-423-8163','ferdinand_hester@yahoo.edu','6192 Convallis Road','13128','13, 43, 73, 31, 19, 97'),
  ('2020-09-15','Rhoda','Rios','(522) 679-0855','r_rhoda@hotmail.ca','P.O. Box 506, 8123 Ornare Rd.','77345','43, 23'),
  ('2021-02-28','Jocelyn','Klein','1-386-634-2852','klein_jocelyn5430@outlook.net','Ap #484-6287 Nulla Rd.','84282','29');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2020-09-18','Kameko','Watkins','(862) 744-9734','watkins.kameko@outlook.org','655-3860 Purus, Street','38605',''),
  ('2022-08-06','Marny','Madden','(216) 833-3537','m.marny@protonmail.org','Ap #298-7840 At, Avenue','48784','23, 1'),
  ('2022-12-31','Cairo','Cannon','1-366-886-5118','cairo.cannon4437@hotmail.edu','P.O. Box 918, 8377 Cursus, Avenue','17307','31, 53, 5, 59'),
  ('2022-05-20','Oren','Copeland','1-887-324-6245','oren.copeland6367@protonmail.net','Ap #125-2807 Sit Rd.','48267','3, 59'),
  ('2020-12-25','Cassandra','Schneider','(483) 893-4148','c.schneider3366@aol.org','843-430 Malesuada Rd.','55783','71'),
  ('2020-08-16','Katell','Wood','(719) 786-9963','k-wood108@hotmail.net','P.O. Box 751, 5768 Fringilla Avenue','83786','53, 89, 61, 73, 67'),
  ('2021-01-11','Raya','Cohen','1-512-467-2397','raya_cohen@google.ca','Ap #693-3731 Vulputate, Rd.','66766','47, 59, 23, 83'),
  ('2022-01-25','Quinn','Poole','(534) 788-7743','quinnpoole@icloud.ca','952-6020 Lacus. Avenue','55974','73, 89, 47, 23, 11, 53'),
  ('2021-07-31','Alana','Bird','1-226-487-4519','abird@icloud.edu','3313 Id Rd.','62058','43, 29, 1'),
  ('2022-06-08','Lance','Snow','(262) 732-2259','snowlance3812@aol.org','Ap #865-4446 Dolor. St.','08778','29, 2, 7, 61, 67');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2020-01-08','Astra','Solis','(348) 932-2748','astrasolis6574@icloud.net','172-2875 Euismod Ave','81348','83'),
  ('2022-06-13','TaShya','Copeland','(125) 854-2690','ctashya@outlook.edu','Ap #354-8335 Dis Road','14632','5'),
  ('2021-11-13','Emerson','Mclean','(213) 844-2244','mclean-emerson4705@outlook.ca','Ap #181-5970 Ultrices. Av.','13996','97, 47, 37, 1'),
  ('2020-02-11','Yoshi','Edwards','(869) 742-2468','y-edwards@google.org','P.O. Box 948, 5448 Euismod Rd.','46378','59, 19'),
  ('2021-06-28','Samson','Banks','1-304-266-3055','sbanks8419@hotmail.ca','206 Accumsan Rd.','12877',''),
  ('2022-03-12','David','Park','(424) 871-4849','park-david3627@google.com','1182 Morbi Ave','42682','37, 1, 31, 53'),
  ('2021-02-07','Roary','Mitchell','(913) 316-0134','mitchell.roary@hotmail.edu','Ap #443-1507 Eu Street','53445','1, 41, 37, 5'),
  ('2019-12-22','Thor','Hatfield','(413) 737-3988','hatfield.thor4783@aol.com','472-7530 Arcu. Street','23630','83'),
  ('2021-09-26','Leo','Bush','1-688-581-6611','l_bush3742@aol.org','8320 Sodales Av.','48748','37, 61'),
  ('2021-06-11','Nora','Duran','(480) 805-3882','dnora6716@protonmail.ca','Ap #852-6185 Sagittis. St.','14659','41, 29, 37');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2020-01-03','Ferdinand','Holman','(418) 454-2588','holmanferdinand2799@yahoo.org','324-343 Urna Road','78862','2, 61, 47, 83'),
  ('2020-12-10','Skyler','Spencer','(837) 778-1503','skyler_spencer8336@protonmail.net','Ap #871-6301 Vestibulum, St.','11344',''),
  ('2020-08-14','Gareth','House','(858) 476-3556','house-gareth@icloud.org','152 In St.','61458','29, 67, 53, 11, 73'),
  ('2022-04-03','Bruce','Reynolds','1-876-865-2310','b.reynolds3684@protonmail.org','2019 Ligula. St.','86236','79'),
  ('2020-05-19','Risa','Nixon','(285) 713-3945','nixon-risa@outlook.com','505-2156 Sed St.','14050','17, 83'),
  ('2021-09-28','Hall','Everett','(213) 271-0629','h.everett@yahoo.net','970-1040 Mi Ave','31478','29, 19'),
  ('2022-03-24','Florence','Carver','1-774-676-9803','carver_florence@hotmail.ca','831-4123 Lacus. Road','87658','29'),
  ('2020-04-05','Alika','Cobb','(721) 723-5905','cobb.alika1416@outlook.edu','536-7068 Tristique St.','34030','5, 89'),
  ('2022-01-06','Omar','Alford','(255) 621-6728','o_alford4247@icloud.com','Ap #137-2761 Velit Rd.','86314','53, 31, 2, 47, 67'),
  ('2020-09-05','Tana','Blanchard','1-591-897-1513','tana-blanchard7176@aol.com','P.O. Box 301, 1408 Enim Av.','45673','5, 23');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2022-02-13','Sheila','Sykes','(249) 448-8273','s.sykes@yahoo.net','Ap #264-4011 Eu St.','48344','23, 67, 3, 43, 73'),
  ('2021-10-23','Tyler','Welch','1-710-767-4736','tyler-welch4008@aol.net','Ap #714-5150 Non St.','73175',''),
  ('2020-07-17','Willa','Acosta','(181) 713-3256','a-willa4982@protonmail.org','P.O. Box 153, 7353 Amet Rd.','13154','3, 43'),
  ('2020-05-18','Cameron','Pena','(469) 744-1722','pena.cameron3269@yahoo.com','P.O. Box 652, 8538 Nunc Rd.','35972',''),
  ('2020-09-09','Hyacinth','Moore','1-457-788-3581','m.hyacinth5229@hotmail.ca','P.O. Box 983, 6429 Faucibus Avenue','89212',''),
  ('2022-09-27','Yoshio','Trevino','(220) 653-6855','t.yoshio2197@protonmail.net','Ap #445-3221 Mauris Avenue','67780','73, 13, 2, 23'),
  ('2021-07-10','Orla','Strickland','(222) 859-7345','strickland.orla@icloud.net','803-9493 Nec, Road','29432','73, 59, 41, 11, 13, 79'),
  ('2021-06-10','Risa','Henderson','1-668-322-5274','risa_henderson@icloud.com','5444 Facilisis, Rd.','22171','43, 41'),
  ('2021-06-25','Sophia','Dillon','1-196-541-4753','dillon_sophia8275@aol.com','Ap #588-8054 Eu Street','87497','61, 23, 19, 73'),
  ('2021-06-13','Winifred','Hanson','1-665-747-2609','w-hanson3318@aol.edu','563-8907 Ac, Road','35620','41, 47, 83');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2022-02-16','Charde','Burks','(476) 271-3663','charde.burks1095@icloud.org','P.O. Box 566, 310 Vel Avenue','67363','79, 71, 19'),
  ('2021-12-20','Roth','Mcneil','1-479-776-6629','mcneil-roth2142@google.edu','Ap #318-9388 Imperdiet, Rd.','68317','67, 43, 37, 53, 3'),
  ('2020-02-01','Karen','Bond','1-283-737-1918','karenbond@icloud.net','692-5223 Nulla Rd.','85668','31, 43, 67, 79'),
  ('2021-03-03','Cedric','Dennis','1-237-221-1591','cedric-dennis6431@icloud.com','9110 Ut Rd.','15525','71, 89, 11, 67, 43'),
  ('2019-12-08','Pamela','Peters','1-775-715-4259','peters.pamela4522@yahoo.net','Ap #318-2969 Mauris Street','77730','89, 5, 23, 3'),
  ('2022-07-03','Vincent','Lamb','1-568-206-3494','lamb_vincent@protonmail.edu','Ap #128-1319 Eleifend. Avenue','84903','71, 41, 3'),
  ('2021-04-12','Gage','Curry','1-561-746-5416','gage-curry4822@google.net','321-2407 Sed Av.','12661','7, 17, 53'),
  ('2020-01-29','Melinda','Sykes','(885) 474-4147','msykes@protonmail.edu','P.O. Box 498, 1382 Tincidunt Street','74265','11'),
  ('2021-08-08','Dacey','English','1-645-264-6682','english.dacey@yahoo.com','162-2306 Dolor Rd.','47693','71, 7, 3, 73'),
  ('2021-10-24','Jillian','Glass','(269) 737-6991','j_glass@google.com','Ap #831-3173 Dolor Road','07456','13, 89, 47, 1');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2022-01-20','Raphael','Villarreal','(152) 337-0727','villarrealraphael@outlook.edu','4771 Sem Road','18584','17, 41, 61'),
  ('2021-03-09','Sylvester','Snow','(219) 468-4157','ssnow5683@aol.org','Ap #280-5991 Erat. Rd.','24356',''),
  ('2021-12-17','Aileen','Andrews','1-353-514-2653','andrews-aileen1446@protonmail.net','613-9235 Quisque Rd.','84028','59, 73'),
  ('2021-07-17','Wylie','Welch','(797) 532-7406','wylie.welch6168@google.com','Ap #418-1828 Sit Avenue','56638',''),
  ('2021-11-06','Jonas','Barnett','1-412-746-5556','barnett-jonas6940@yahoo.edu','Ap #341-5173 Scelerisque, Av.','73841','1, 31, 29'),
  ('2021-02-24','William','Beck','(714) 789-9154','beck.william@aol.com','P.O. Box 204, 3262 Mauris Street','91375','17, 79, 1, 37'),
  ('2021-10-09','Wyoming','Smith','1-881-787-7724','wyoming-smith@protonmail.edu','Ap #958-5220 Pellentesque, Rd.','58558','79, 5, 19'),
  ('2021-07-18','Amos','Roy','1-192-343-9222','a-roy@icloud.net','Ap #251-5944 Nec Av.','68681','2'),
  ('2020-12-17','Shannon','Haynes','1-734-575-8243','shannonhaynes@outlook.edu','7277 Elementum, St.','51733','97, 19'),
  ('2020-01-25','Frances','Mason','(366) 317-2087','frances-mason5872@yahoo.ca','411-6235 Praesent St.','52519','41, 23, 19');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2019-12-25','Joshua','Whitehead','(845) 488-5273','w.joshua@yahoo.edu','P.O. Box 536, 8694 Lorem, St.','92833','23, 79, 59'),
  ('2020-08-22','Elijah','Sutton','1-637-703-2828','e-sutton@outlook.com','Ap #976-1457 Nisi Rd.','56564','41, 11, 73, 67, 37'),
  ('2020-08-03','Alvin','Leblanc','1-618-221-7572','leblancalvin924@protonmail.edu','9136 Nulla. Ave','77274','31, 19, 7, 83, 59, 23'),
  ('2021-01-23','Phyllis','Valencia','1-141-412-8235','p_valencia4006@yahoo.edu','872-1827 Per Avenue','02868',''),
  ('2022-04-21','Levi','Shepard','(594) 814-8173','shepard-levi1023@protonmail.org','Ap #844-1788 Aliquet, Street','60782','79, 41, 89, 5, 47, 97'),
  ('2021-10-15','Glenna','Carver','1-134-220-8142','c-glenna@hotmail.edu','728-8005 Nunc Road','16312','3, 37, 53, 79'),
  ('2022-10-14','Mona','Peck','(421) 234-6766','mpeck@hotmail.org','P.O. Box 414, 3031 Lectus Rd.','42963','7, 53, 47'),
  ('2021-10-02','Aretha','Soto','(174) 646-9723','soto_aretha5088@hotmail.net','P.O. Box 278, 9856 Sit Road','32582',''),
  ('2021-03-14','Maryam','Fox','(160) 607-8982','m_fox9650@aol.com','Ap #850-9959 Ornare, Road','47477','47, 37, 19, 83'),
  ('2021-02-15','Elton','Velez','1-376-447-6717','v_elton4119@protonmail.edu','Ap #822-3411 Aliquam St.','32065','73, 7, 2, 29');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2021-12-29','Lewis','Everett','1-761-251-4535','l_everett3136@protonmail.edu','719-9546 Nullam Av.','71951','2'),
  ('2020-07-24','Garth','Pennington','1-778-554-5678','g.pennington5566@google.net','P.O. Box 566, 9795 Nam Rd.','12522','11, 37, 2'),
  ('2022-09-09','Harlan','Morton','(757) 845-4342','h-morton@protonmail.net','Ap #662-2898 Vestibulum Ave','58105','29, 67, 41, 79, 7'),
  ('2021-07-01','Dustin','Whitney','1-301-354-7881','d_whitney4542@icloud.ca','520-2537 Enim. St.','72986','2, 5, 19, 53, 97'),
  ('2021-07-30','Jasper','Kim','1-143-468-9313','j.kim@outlook.com','P.O. Box 872, 5866 Nec, Ave','37533','41, 5, 73, 89, 83'),
  ('2020-07-07','George','Coleman','1-533-776-3039','george_coleman@outlook.org','P.O. Box 867, 6908 Dictum Av.','06295','53, 19, 31, 3, 61'),
  ('2021-10-15','Illana','Thomas','(477) 843-0624','thomas-illana1607@google.org','6669 Tincidunt St.','07711','17, 97, 7, 37'),
  ('2020-09-09','Hiroko','Little','(553) 213-3443','lhiroko@protonmail.org','470-5449 Orci Rd.','71542','13'),
  ('2020-05-16','Kasimir','Saunders','1-562-362-3396','saunders_kasimir6204@google.edu','541-9134 Metus. Avenue','18910',''),
  ('2020-09-22','Nasim','Leblanc','1-712-647-4838','n.leblanc@google.com','P.O. Box 929, 8357 Sociis Avenue','44483','71');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2022-02-12','Rhona','Hatfield','(536) 277-2179','r.hatfield@protonmail.edu','Ap #110-6775 Amet Ave','24851',''),
  ('2021-05-12','Angela','Robinson','(416) 997-3120','robinson-angela@aol.com','Ap #297-4674 Rutrum. Rd.','63845','17, 11, 3, 97'),
  ('2022-05-22','Natalie','Strickland','1-335-198-6416','strickland-natalie@outlook.edu','P.O. Box 563, 6969 Et St.','57125','41, 61'),
  ('2021-10-22','Jordan','Gutierrez','1-557-861-3516','gutierrezjordan@aol.edu','731-6200 A St.','47306','41, 47'),
  ('2020-11-03','Xena','Mcleod','(874) 398-4566','mcleodxena@outlook.ca','770-7761 Velit Rd.','86618','97'),
  ('2021-12-04','Francis','Woods','1-805-643-8556','woods.francis@outlook.net','2104 Risus Rd.','24535','41, 2'),
  ('2020-02-22','Germane','Drake','(529) 734-6606','gdrake2720@hotmail.ca','221-3138 Lorem, St.','45222',''),
  ('2020-08-04','Macon','Serrano','1-855-552-1083','m_serrano@yahoo.edu','134-7629 Donec Rd.','91474','47, 31'),
  ('2020-07-01','Hilda','Sweeney','(222) 912-5614','sweeney_hilda@hotmail.ca','Ap #785-4243 Penatibus Av.','05732','89, 23, 97, 13, 83'),
  ('2020-10-12','Chava','Garner','(258) 698-3152','garner-chava@google.ca','Ap #392-6432 Porta St.','51348','31, 83');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2020-12-04','Brian','Powers','1-364-974-5807','brian.powers@protonmail.com','P.O. Box 462, 2225 Laoreet Av.','38896','71, 1, 73'),
  ('2020-01-18','Ray','French','1-383-336-0251','french-ray@google.com','427-6943 Nullam Ave','42174','89, 53, 43, 83, 41, 19'),
  ('2021-10-17','Jayme','Hood','(981) 434-2761','jhood@aol.edu','517-644 Euismod Rd.','36134','43, 31, 53, 71, 59, 83'),
  ('2021-01-29','Lilah','Wiley','(777) 329-5539','wiley_lilah@google.ca','940-9865 Eu Avenue','71549','29, 7, 71, 43, 23, 5'),
  ('2021-01-16','Zephr','Downs','(995) 684-9063','zdowns@protonmail.ca','P.O. Box 561, 7033 Non Road','76477','2, 5, 83, 73'),
  ('2021-06-08','Kathleen','Burton','(711) 910-5839','k-burton@hotmail.edu','663-3553 Fames Avenue','75120','53, 97'),
  ('2020-09-20','Flavia','Adams','1-387-841-2484','adamsflavia8498@hotmail.edu','Ap #971-392 Pede St.','83466','53, 97, 17'),
  ('2021-11-23','Gillian','Munoz','1-583-383-1763','g-munoz@hotmail.ca','Ap #788-5718 Vel, Street','21834','1, 71'),
  ('2021-02-21','Elliott','Todd','1-127-854-6704','elliott-todd@hotmail.ca','270-6966 Molestie. Ave','07048','1, 47, 23'),
  ('2020-01-06','Jerome','Wade','(883) 770-7805','jerome_wade@aol.com','482-7249 Iaculis Ave','16867','61, 31, 13, 83, 41');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2021-04-17','Shafira','Campbell','1-436-735-7284','cshafira8410@protonmail.ca','482-3663 Quisque Rd.','75748','2, 13'),
  ('2022-12-31','Ivan','Spence','1-521-670-5643','i.spence1134@icloud.com','Ap #946-7671 Bibendum St.','73244','79, 3, 19, 89'),
  ('2021-08-27','Desirae','Bray','1-299-306-2315','desiraebray7111@google.ca','380-1067 Malesuada Av.','76245','19, 59'),
  ('2020-10-19','Brady','Mcclure','1-212-146-8784','brady.mcclure3721@hotmail.net','778-1178 Blandit. Av.','21519','5, 2'),
  ('2020-09-12','Brady','Bernard','1-501-835-6675','bbernard9518@google.edu','115-200 Pellentesque Rd.','51368','79, 31, 43, 67, 71, 1'),
  ('2020-06-11','Marvin','Pope','(857) 524-4750','popemarvin@hotmail.org','806-1613 Id Ave','21132','23'),
  ('2020-12-18','Ira','Terrell','(941) 263-1753','iraterrell1867@protonmail.ca','807-2179 Sit Avenue','18582','61, 79, 17, 83, 41'),
  ('2022-10-03','Quamar','Good','(733) 281-4982','good_quamar@outlook.net','Ap #565-167 Mollis. Av.','46841','3, 29, 61, 23'),
  ('2022-09-04','Dolan','Dawson','(944) 848-3998','dawson_dolan9325@hotmail.ca','P.O. Box 167, 7892 In Road','62878','31, 67'),
  ('2020-01-17','Harper','Edwards','1-605-686-2615','h-edwards7932@google.com','Ap #912-4314 Adipiscing Rd.','31805','73, 67, 29, 79');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2022-05-17','Alexander','Prince','1-814-862-6298','princealexander@google.ca','8851 Phasellus Street','58601','61, 5, 29, 41'),
  ('2020-01-31','Idola','Miles','(875) 461-9581','idola_miles@aol.net','1328 Velit Ave','73058','17, 79'),
  ('2021-06-12','Stacy','Crawford','(247) 746-2561','c_stacy@yahoo.edu','4782 Duis St.','98647','79, 2, 89, 7'),
  ('2022-09-03','Zeph','Daugherty','(316) 457-1879','zdaugherty@google.net','Ap #827-8398 Velit St.','73832','17, 43, 13, 41, 53, 2'),
  ('2022-10-21','Damian','Downs','1-811-629-9680','d_downs207@yahoo.org','540-4299 Mi St.','13681','79, 97, 73, 3, 23'),
  ('2022-01-31','Zachary','Barnett','1-951-335-8121','barnettzachary@yahoo.net','2980 Lacinia. Street','26798','1, 29, 73, 7'),
  ('2021-03-28','Warren','Walsh','(373) 740-8371','w-warren@outlook.com','2679 Amet, Rd.','75145','23, 17, 31, 19'),
  ('2020-12-08','Ulysses','Roman','(780) 536-6644','u_roman6726@hotmail.edu','P.O. Box 436, 7105 Mi. Street','74915','17, 5, 89'),
  ('2022-10-25','Kitra','Whitehead','(453) 287-3838','kitrawhitehead@icloud.ca','3654 Cras Road','19089','97, 17, 5, 71, 47'),
  ('2022-07-10','Venus','Bryan','(611) 212-7874','v-bryan@google.ca','4593 Eu Avenue','62453','29');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2020-09-13','Lane','Curtis','(359) 160-3876','l_curtis@icloud.com','P.O. Box 653, 6618 Urna Av.','48743','53, 19'),
  ('2021-03-22','Emmanuel','Doyle','1-996-417-5772','d_emmanuel1563@icloud.edu','Ap #790-5745 Per Street','82936','89, 19, 37, 5, 23'),
  ('2020-07-04','Rudyard','Bennett','(472) 733-9177','rbennett@hotmail.net','P.O. Box 917, 4817 Et, Av.','27693','1, 37, 2, 53, 17'),
  ('2021-04-29','Hamilton','Dennis','(595) 144-5012','dennis.hamilton1736@yahoo.net','Ap #555-850 Tortor. Av.','15038',''),
  ('2022-08-12','Deanna','Castillo','(155) 417-5476','castillo-deanna@outlook.net','559-7179 Parturient Rd.','26492','61, 1'),
  ('2022-10-29','Yoshi','Wheeler','1-963-827-4250','ywheeler@icloud.com','Ap #982-2082 Iaculis Rd.','01706','37, 19, 73, 29, 31'),
  ('2021-09-17','Kibo','Rhodes','(769) 415-2432','rhodes_kibo7826@outlook.com','8661 Ullamcorper, Avenue','08013','1, 73, 13'),
  ('2020-08-25','Jolie','Douglas','1-232-654-1484','jolie.douglas7459@google.ca','9922 Orci Avenue','26438','83, 23, 19'),
  ('2022-10-16','Steel','Bright','1-983-656-6865','s_bright@protonmail.org','301-948 Eu, Road','20198','31, 43, 73, 59, 37, 11'),
  ('2022-04-22','Abra','Beard','(516) 726-8592','beard_abra@protonmail.edu','Ap #215-9393 Commodo Av.','77242','23, 59, 43');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2021-03-28','Jason','Meadows','1-261-882-2453','j.meadows@protonmail.net','P.O. Box 666, 8387 Maecenas Rd.','90469','3'),
  ('2020-08-23','Deacon','Mayer','1-561-718-5801','mayer.deacon8885@yahoo.org','3577 Aliquam Avenue','22575','79, 31'),
  ('2022-04-03','Inez','Joseph','1-658-125-9841','i.joseph@google.com','Ap #311-6906 Sit St.','24381','61, 31, 11'),
  ('2021-03-06','Jeremy','Reese','(370) 636-6697','reese-jeremy5960@hotmail.edu','Ap #460-1875 Commodo Rd.','11157','73, 11'),
  ('2019-12-23','Randall','Mullins','(160) 611-6552','r.mullins3318@hotmail.edu','593-9228 Natoque Road','23023','2, 31, 37'),
  ('2021-08-31','Candace','Jimenez','1-774-206-7243','c-jimenez5623@google.com','7304 In Rd.','07429','11, 37, 41'),
  ('2021-04-10','Remedios','Carpenter','(767) 981-2138','r-carpenter9479@protonmail.edu','Ap #840-4468 In Street','55627','11, 1, 17, 97'),
  ('2020-01-19','Beatrice','Hatfield','(488) 284-3331','b-hatfield@aol.ca','469-600 Aliquam Rd.','54342','79, 43'),
  ('2020-05-17','Quentin','Tillman','1-676-757-1417','tillman-quentin9192@icloud.ca','201-5422 Erat, Avenue','83434',''),
  ('2021-02-11','Delilah','Franklin','(978) 123-9578','franklin_delilah@yahoo.org','619 Morbi Ave','04164','');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2020-08-08','Alexander','Whitney','(173) 339-5031','walexander910@google.org','P.O. Box 514, 3044 Tincidunt Av.','87496','23, 79, 89, 53'),
  ('2020-05-27','Neil','Davidson','(689) 470-4826','n.davidson6793@icloud.com','560-8183 Ultrices Road','58384','5, 29, 59'),
  ('2021-10-28','Daphne','Donaldson','(802) 944-6540','ddonaldson@yahoo.edu','708-5352 Metus. Rd.','58863','83, 73, 71'),
  ('2020-05-31','Whoopi','Perkins','1-234-784-7830','perkinswhoopi@aol.com','P.O. Box 430, 5994 Neque. Road','62242','19, 89, 23, 97, 59'),
  ('2020-08-21','Kirk','Vance','(326) 688-5562','kvance8777@yahoo.edu','Ap #247-700 Sapien. Rd.','60344','3, 23'),
  ('2020-04-14','Brynn','Odom','1-139-659-6813','brynn.odom4967@aol.net','Ap #614-2986 Sed Road','25171',''),
  ('2020-08-23','Abbot','Haynes','(339) 183-7673','abbot_haynes@hotmail.net','P.O. Box 635, 8240 Rutrum Av.','75267',''),
  ('2021-10-14','Jordan','Steele','(474) 539-7058','jordansteele8654@yahoo.org','P.O. Box 809, 3598 Mi St.','12388','41, 83'),
  ('2021-03-30','Paula','Dodson','1-566-239-7388','paula.dodson@yahoo.org','508-4212 Nunc Avenue','53127','59, 43, 7, 41'),
  ('2021-02-19','Herrod','Wilder','(458) 672-1992','w.herrod@hotmail.org','Ap #750-1187 Cursus Street','65359','43, 1, 17, 61, 29');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2020-05-25','Omar','Chambers','(250) 628-3310','o-chambers@aol.net','P.O. Box 384, 1138 Mi St.','31146','61, 73, 31'),
  ('2020-12-09','Lois','Mcleod','(200) 405-7177','l-mcleod1819@yahoo.ca','310-9327 Nascetur Ave','40210','2, 71, 1'),
  ('2020-05-17','Kyla','Matthews','1-646-287-8516','m_kyla9229@google.com','Ap #957-7725 Cras Av.','79122',''),
  ('2021-04-02','Stephanie','Watts','1-431-567-2512','watts.stephanie@protonmail.net','7378 Ligula. Street','71768','89'),
  ('2022-03-19','Hedy','Hopkins','(617) 973-1269','h_hopkins@yahoo.ca','P.O. Box 520, 6674 Quis Street','43253','7'),
  ('2021-01-02','Ciaran','Bright','1-615-510-6492','brightciaran@icloud.net','Ap #958-7816 Nisi. St.','75456','29, 1, 61'),
  ('2020-06-25','Ainsley','Hodge','(286) 734-4521','ainsley_hodge276@protonmail.net','Ap #832-7751 Enim Road','06694','19, 2'),
  ('2022-06-08','Moana','Craft','1-642-363-3328','c-moana3722@icloud.ca','P.O. Box 330, 3540 Cubilia Road','40324',''),
  ('2021-06-13','Juliet','Macdonald','1-599-237-6484','juliet-macdonald3424@yahoo.net','P.O. Box 530, 1860 Et Ave','85800','11, 17, 79'),
  ('2022-10-11','Hilda','Aguilar','1-765-512-2788','hilda_aguilar@yahoo.net','248-6176 Proin St.','38474','43, 97, 71, 59, 7');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2022-01-22','Carson','Hicks','(623) 651-2114','hcarson@hotmail.org','2790 Fusce Ave','53262','73, 59, 29'),
  ('2022-10-05','Nichole','Caldwell','(646) 371-7314','caldwell-nichole2913@icloud.com','Ap #380-6854 Cras Ave','61613',''),
  ('2021-05-22','Martina','Morgan','(555) 333-8953','m.martina1722@outlook.edu','Ap #937-9748 Sed St.','15743','3, 29, 47'),
  ('2020-10-25','Aristotle','Cantu','1-815-336-0676','cantu.aristotle9673@google.org','Ap #893-4513 Maecenas St.','46825',''),
  ('2021-04-22','Jane','Wiggins','1-247-792-8438','wiggins_jane@hotmail.ca','539-359 A Av.','65433','19'),
  ('2020-10-11','Noble','Wallace','1-654-216-7547','noble-wallace2383@outlook.edu','P.O. Box 370, 8984 Congue. Rd.','16249','5'),
  ('2021-04-15','Dane','Marquez','(414) 904-6665','d.marquez@yahoo.edu','Ap #542-5780 Justo Rd.','78149','3, 89, 37, 47'),
  ('2020-05-25','Thomas','Munoz','1-780-224-3814','munoz-thomas7113@google.ca','619-2880 Ac Avenue','55045','23, 61'),
  ('2021-07-23','Alexis','Davenport','(402) 226-2070','dalexis@hotmail.com','P.O. Box 642, 8552 Libero Street','95481','67, 79'),
  ('2021-02-16','Minerva','Hatfield','(215) 771-8885','mhatfield@protonmail.com','Ap #482-8742 Lacus Rd.','64971','3, 97, 13');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2022-06-20','Vincent','Vang','(822) 853-6825','vvang6415@yahoo.net','7675 Et Av.','27480','47, 7, 37'),
  ('2021-11-20','Allistair','Cobb','(266) 722-8634','cobb.allistair9065@protonmail.net','P.O. Box 507, 510 Penatibus St.','74168','61, 37, 47, 97'),
  ('2020-10-14','Noble','Pacheco','(202) 175-8836','n.pacheco1048@aol.net','142-6272 Arcu Rd.','15135','71, 41, 13, 23'),
  ('2021-06-28','Isaac','Willis','(341) 112-3283','w.isaac@icloud.org','536-2742 Et St.','23597','17'),
  ('2022-10-17','Olivia','White','(230) 514-5355','olivia-white@outlook.ca','P.O. Box 768, 4917 Pretium Street','37556','47, 83, 97, 89'),
  ('2020-01-05','Kaye','Bailey','1-218-641-6488','k_bailey4903@hotmail.org','Ap #145-211 Proin Rd.','71707','89'),
  ('2020-06-29','Cleo','Montoya','1-480-844-2318','mcleo@aol.net','668-8409 Et, Rd.','82763','41, 11, 89'),
  ('2022-01-16','Sonya','Yang','1-660-536-4214','y-sonya5596@yahoo.org','Ap #596-5827 Erat Road','07567','59, 41, 11, 23'),
  ('2020-08-15','Nigel','Cannon','(616) 947-3582','nigelcannon@hotmail.org','P.O. Box 468, 7915 In Ave','04812','37'),
  ('2020-10-15','Kato','Mayo','1-334-425-3810','mayo-kato@aol.net','3816 Convallis Rd.','57511','7, 61, 13, 29, 59, 47');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2020-06-26','Althea','Strickland','1-531-775-6507','salthea@icloud.net','375-109 Molestie St.','26341','83, 13'),
  ('2021-10-05','Damian','Benjamin','1-328-476-5121','benjamindamian995@protonmail.org','650-3867 Donec St.','78272','59, 37, 53, 79, 71'),
  ('2020-11-27','Brenden','Ayers','1-717-586-7878','b_ayers@google.edu','P.O. Box 883, 944 Dui Avenue','86742','71'),
  ('2020-08-25','Hiram','Richardson','(207) 292-9602','richardson.hiram4824@icloud.edu','110-1843 Convallis Street','03748','1, 73, 5, 67'),
  ('2021-02-01','Aidan','Waters','1-724-656-8138','aidan-waters8451@outlook.org','240-7966 Nisi. St.','17675','17, 73, 43, 7, 83'),
  ('2021-01-21','Tamekah','Kidd','1-375-741-7582','t.kidd@hotmail.ca','2947 Semper Rd.','11388','37, 7, 97, 2, 79'),
  ('2021-12-01','Yasir','Shepard','1-853-707-4737','shepard.yasir@icloud.com','P.O. Box 767, 6870 Iaculis Road','44562','3, 41, 11'),
  ('2021-12-09','Yoko','Hendrix','1-691-231-9984','h.yoko9841@protonmail.org','868-1819 Elit, St.','76355','97, 23, 89'),
  ('2021-02-02','Hanna','Noel','(887) 983-2672','h_noel@icloud.net','Ap #950-9739 Facilisis Avenue','11595','2, 71'),
  ('2022-01-25','Sebastian','Salas','1-872-546-5846','salas-sebastian@protonmail.org','705-3233 Eu Road','84166','1, 97, 71, 67');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2021-06-21','Destiny','Fields','1-857-863-5323','d_fields@protonmail.org','Ap #708-7443 In Av.','60115',''),
  ('2020-11-05','Dylan','Vaughan','1-221-125-7341','d_vaughan1675@aol.com','Ap #747-1972 Ut Rd.','60406','41, 7'),
  ('2021-06-30','Donna','Cantrell','1-442-427-2974','cantrell-donna@google.net','470-118 Sed Rd.','46314','3, 37'),
  ('2021-06-17','Armand','Good','(527) 317-2492','a.good@google.edu','Ap #183-3577 Elementum Rd.','76022','23, 61, 71'),
  ('2020-07-24','Odessa','Ray','1-747-432-3842','ray.odessa7382@icloud.net','145-7439 Urna. Rd.','24874','43'),
  ('2022-05-22','May','Pope','1-502-275-3462','mpope3245@yahoo.ca','Ap #437-9286 Lacus. Av.','36425','73, 97, 11'),
  ('2021-11-17','Chadwick','Holder','(522) 373-1833','h_chadwick8856@outlook.edu','P.O. Box 657, 6721 Dignissim Street','13443','89, 19'),
  ('2021-03-05','Thomas','Blackwell','(704) 515-1688','b-thomas5770@google.net','467-6362 Tempor Rd.','07586','19, 3, 53, 83'),
  ('2020-03-14','Cade','Wolfe','1-385-582-6172','wolfecade@aol.com','644-2987 Sollicitudin Road','19251','79, 59, 1'),
  ('2022-10-24','Vera','Ferrell','(861) 938-5651','f.vera@hotmail.org','Ap #921-9992 Id, Av.','12416','97, 11, 41, 23');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2021-08-24','Elvis','Hayden','(883) 513-8039','e_hayden@hotmail.com','P.O. Box 444, 6647 Tempus Ave','85895',''),
  ('2021-03-21','Sean','Lucas','(289) 713-4355','lucas-sean3483@aol.edu','Ap #396-5513 Et Avenue','24406','43, 53, 67, 83, 3, 73'),
  ('2021-12-02','Garrett','Cook','1-551-259-9124','cookgarrett@icloud.com','P.O. Box 703, 3824 Nulla Av.','54544','43, 73, 1, 89, 83'),
  ('2020-12-29','Beatrice','Robbins','1-998-335-0181','b_robbins@hotmail.ca','Ap #662-4696 Dapibus Rd.','82770','3, 97, 41, 73, 23'),
  ('2022-07-06','Patrick','Burns','1-735-375-2292','burnspatrick7021@aol.com','874-4932 Posuere Rd.','68414','23, 5, 31, 97, 73, 47'),
  ('2021-03-20','Finn','Mccormick','1-225-972-7432','f.mccormick@aol.net','628-9641 Est, Ave','49091','11, 47, 71, 43, 59, 67'),
  ('2022-07-27','Lillith','Vaughn','(544) 423-2858','l.vaughn4459@google.edu','Ap #727-8505 Augue. Rd.','39811','13, 17, 73, 31'),
  ('2021-08-23','Sybil','Cantu','1-855-549-2529','c_sybil@yahoo.org','734-883 Non Rd.','28546','73, 59'),
  ('2022-10-28','Karina','Tucker','1-287-246-0416','ktucker@google.net','315-7442 Sit Avenue','56413','11, 3, 1, 5, 83'),
  ('2020-11-29','Cyrus','Frazier','1-137-550-3753','cfrazier@google.net','9025 Non Street','54596','43, 31, 29, 61, 59, 17');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2020-01-11','Myles','Goff','(744) 628-3236','mylesgoff@outlook.ca','Ap #694-8179 Tortor. Avenue','76614',''),
  ('2021-01-15','Lewis','Kirk','(945) 229-6113','kirk_lewis4388@google.com','321-2284 Elit, Avenue','78076','61, 59'),
  ('2022-06-01','Nash','Knox','1-740-411-5937','knox_nash5007@icloud.org','Ap #833-2992 Euismod Rd.','18282','31, 47, 89'),
  ('2021-05-12','Amena','Valdez','1-771-457-1458','amena_valdez@protonmail.edu','490-5345 Non, St.','90968','19, 97, 37, 11'),
  ('2020-09-15','Mari','Hodges','(741) 234-2424','hodges_mari9452@google.edu','226-6651 Est St.','33276','37'),
  ('2021-05-08','Madison','Leblanc','1-521-346-6472','l.madison9589@hotmail.com','893-1169 In Street','58546','7, 31, 23, 71, 2, 37'),
  ('2020-03-31','Nigel','Wilkins','1-305-584-4845','n.wilkins@icloud.ca','Ap #660-1570 Mi Avenue','35541','13, 73, 11, 53, 3'),
  ('2020-12-05','Sheila','Bradford','1-668-457-1327','s.bradford@icloud.org','P.O. Box 904, 7262 Vitae Street','45663','79, 5, 23'),
  ('2020-08-19','Stone','York','1-517-379-4273','york_stone5689@icloud.org','1449 Blandit. Avenue','48868','47, 61, 89, 11, 43, 41'),
  ('2020-09-20','Ralph','Padilla','(756) 253-4613','rpadilla@hotmail.ca','Ap #990-4589 Donec St.','82166','31, 3, 2, 79, 13');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2020-05-02','Cheryl','Baldwin','(234) 808-4649','baldwin.cheryl5121@google.ca','P.O. Box 374, 2671 Quisque Road','59532','43, 37'),
  ('2020-10-04','Sydnee','Mendoza','(691) 479-6148','m_sydnee3471@outlook.org','512-6092 Pharetra. Av.','79663','43, 31, 59, 97, 83, 13'),
  ('2021-04-03','Myles','Vaughan','1-445-233-5628','v_myles301@icloud.net','902-9221 Nulla. St.','78882','43, 79, 89, 1, 97'),
  ('2022-12-31','Whoopi','Franks','(841) 717-7387','frankswhoopi9045@google.org','P.O. Box 612, 6100 Fames Road','27454','5, 2'),
  ('2022-10-20','Melyssa','Garrison','(313) 644-2505','garrison.melyssa4909@aol.org','937-3168 Enim. St.','76232','79, 41, 23, 61'),
  ('2022-07-19','Castor','Nolan','(241) 454-3173','castor.nolan@protonmail.org','P.O. Box 722, 1725 Faucibus St.','72863',''),
  ('2022-04-22','Paul','Garcia','1-587-252-4227','p_garcia7049@yahoo.edu','Ap #421-2463 Vivamus Road','23552','7, 73, 71, 61'),
  ('2022-02-04','Uriah','Martin','(753) 141-3771','u_martin156@icloud.edu','943-2094 Ante Rd.','43419','41, 5, 7, 2, 17'),
  ('2020-07-24','Samuel','Donaldson','(345) 113-6258','s-donaldson@aol.edu','P.O. Box 539, 664 Vitae, Rd.','26855','59, 2, 37, 47, 71, 3'),
  ('2020-06-01','Acton','Harris','(358) 444-2725','a-harris@outlook.ca','883-6848 Magna St.','26256','83, 23, 19, 53, 17');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2021-04-03','Courtney','Hendrix','(512) 691-4613','hendrix.courtney7847@yahoo.net','836-880 Pede. Rd.','07378','17'),
  ('2021-11-25','Judith','Barry','(929) 527-5287','judith_barry5956@google.ca','P.O. Box 585, 6764 Ullamcorper, St.','78046','19, 31'),
  ('2020-01-28','Hanae','Stokes','(593) 561-2281','hanaestokes5050@google.com','849-3119 Praesent Street','59866',''),
  ('2019-12-10','Kaseem','Foley','1-963-237-1437','foley-kaseem1897@aol.com','Ap #717-4269 Est, Street','80617','5, 47, 73'),
  ('2021-01-27','Rowan','Holmes','1-762-311-3441','rowanholmes6269@google.com','528-137 Et, St.','40466','43, 67, 41'),
  ('2020-05-18','Timothy','Odom','1-435-245-8680','o_timothy6930@icloud.net','799-1128 Sem. Rd.','60489','89, 67, 23, 97'),
  ('2020-04-17','Isadora','Blackburn','(583) 637-6541','isadora_blackburn@aol.org','P.O. Box 137, 3816 Accumsan St.','59446','11, 2, 29'),
  ('2022-04-20','India','Cash','(912) 781-2451','indiacash9734@protonmail.net','893-7303 Adipiscing St.','64543','43, 83, 11, 1, 79'),
  ('2020-04-30','Burke','Rogers','1-130-404-3551','r-burke715@yahoo.com','338-8735 Cursus St.','56537','53, 31, 47'),
  ('2020-11-15','Anastasia','Ochoa','(227) 848-8215','a.ochoa@google.org','Ap #891-2184 Nec Street','32713','19, 79, 89');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2020-01-04','Ronan','Shannon','(667) 285-5083','r.shannon687@outlook.com','P.O. Box 798, 9084 Natoque Rd.','33972','83'),
  ('2022-05-15','Hamish','Dodson','1-849-583-3331','dodsonhamish125@aol.edu','2789 Dignissim Rd.','63265','19, 59, 89, 7, 53'),
  ('2021-03-27','Reece','Cantrell','(510) 758-1643','r_cantrell4562@aol.ca','6776 Felis, Rd.','42331','31, 37'),
  ('2020-12-25','Driscoll','Harris','(795) 218-6333','harris.driscoll@google.net','P.O. Box 870, 4041 Imperdiet Rd.','82515',''),
  ('2021-12-12','Lucian','Christian','1-334-933-4382','christianlucian7322@yahoo.com','Ap #648-3411 Lacus. Rd.','09337','47, 13, 37, 17'),
  ('2021-08-17','Richard','Meadows','(831) 466-2159','meadowsrichard@hotmail.net','5204 Nisi Ave','17585','31, 47'),
  ('2021-06-26','Reece','Copeland','1-716-545-1986','r-copeland6093@outlook.org','P.O. Box 224, 1042 Nisi Rd.','42586','41, 89, 7, 13, 83'),
  ('2021-06-28','Amal','Sheppard','(733) 898-2457','a-sheppard2228@hotmail.edu','417-8574 Quam. Rd.','80914','17, 3, 61, 53'),
  ('2020-12-03','Kameko','Mccullough','(281) 976-3833','kameko-mccullough@outlook.edu','2779 Sem, St.','58775','59, 7, 73, 41'),
  ('2020-07-16','Ezra','Lester','(713) 766-4704','e-lester7617@protonmail.com','697-7291 Maecenas St.','15171','31, 59, 53');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2020-10-30','Brendan','Cox','(636) 758-3365','c-brendan7760@protonmail.org','P.O. Box 240, 237 Sollicitudin Rd.','81524','41, 2, 89, 71, 79'),
  ('2020-11-18','Abraham','Conner','(186) 526-5286','conner.abraham1688@hotmail.org','225-7430 Eu, Rd.','15715','53, 89, 1, 79'),
  ('2020-08-02','Kirk','Albert','1-335-159-2285','kalbert4730@aol.org','905-8939 Lorem Av.','66703','1'),
  ('2021-04-15','Felix','Hernandez','1-483-490-1767','hernandezfelix@protonmail.edu','Ap #207-7650 Mauris Ave','46703','43, 47, 19, 2, 3, 53'),
  ('2020-05-31','Erasmus','Pruitt','(905) 323-4509','erasmus_pruitt6511@icloud.ca','P.O. Box 951, 1392 Pharetra Road','71448','43, 17, 61'),
  ('2021-05-06','Rana','Knight','(407) 284-3254','r.knight@outlook.ca','2264 Quis, Ave','34118','47'),
  ('2022-05-18','Hope','Dalton','1-346-342-6935','dalton.hope@google.org','425-1357 Metus St.','81544','13, 3'),
  ('2022-05-18','Iona','Hodge','(881) 361-2861','h.iona@hotmail.com','421-1896 Nullam Avenue','03191','7'),
  ('2021-08-26','Colton','Collins','(923) 525-8146','ccollins8562@protonmail.edu','Ap #902-9332 Tempus Street','65355','61, 13'),
  ('2022-02-22','Nicole','Ferguson','1-817-526-4013','nicoleferguson2856@icloud.org','Ap #408-5062 Lorem Avenue','14854','17, 41, 11, 3');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2022-06-20','Sybill','Jacobson','1-156-714-9384','s.jacobson5982@icloud.ca','P.O. Box 378, 9454 Mauris St.','15534','19, 37, 2, 71, 5'),
  ('2022-07-25','Hamish','English','1-862-677-6871','englishhamish@yahoo.edu','Ap #382-380 Vivamus St.','76234','83, 19, 11, 17'),
  ('2021-05-30','Nora','Cooper','1-400-351-0781','cooper-nora@outlook.com','P.O. Box 892, 7702 Phasellus Rd.','53384','1, 43, 5'),
  ('2020-05-20','Caesar','Hendricks','1-258-402-7542','hendricks_caesar9033@icloud.edu','P.O. Box 403, 9951 Fusce Ave','27175','11, 23'),
  ('2021-12-13','Aurora','Gardner','(867) 123-1781','gardner.aurora@aol.com','P.O. Box 931, 2180 Ac Rd.','87318','11, 17, 7'),
  ('2021-04-23','Dominic','Buchanan','(235) 214-2551','buchanandominic@protonmail.org','Ap #186-8469 Nisi. Ave','37661','13, 3, 73'),
  ('2020-11-19','Cally','Byrd','(918) 295-4988','bcally@yahoo.ca','P.O. Box 241, 2985 Sit Street','58627','59, 2, 53, 23, 11'),
  ('2022-07-08','Kathleen','Hernandez','(709) 354-2633','kathleen.hernandez@aol.com','P.O. Box 984, 1013 Ornare. Street','26121',''),
  ('2022-06-10','Raya','Garcia','1-837-193-8478','g_raya6459@outlook.com','Ap #735-5125 Vulputate, Av.','19286','31, 43, 2'),
  ('2020-01-08','Colleen','Vaughan','1-356-457-0325','cvaughan@aol.ca','3241 Dolor. Avenue','22743','83, 59, 41, 13');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2022-08-16','Henry','Johnson','1-416-483-3054','h.johnson9140@outlook.net','Ap #257-5862 Nonummy. Ave','23046','5, 59'),
  ('2020-06-18','Brynne','Hebert','1-387-573-7844','brynnehebert@icloud.org','Ap #732-4524 Lectus Road','70228','11, 2, 53, 89'),
  ('2021-12-18','Sacha','Downs','1-479-488-3471','d.sacha@yahoo.com','Ap #954-2937 Lorem, Av.','30656','71, 13, 17, 47, 11'),
  ('2020-01-04','Hammett','Guy','1-384-280-1366','g.hammett@google.org','427-453 Mauris Road','38159','47, 5, 37, 17'),
  ('2020-06-12','Cassandra','Workman','(607) 380-4482','cassandraworkman7272@outlook.org','482-2045 Tincidunt St.','04132','2, 19'),
  ('2022-02-08','Gage','Stuart','(963) 158-0625','s_gage6887@aol.ca','P.O. Box 865, 9189 Lectus Rd.','31465','67, 13, 73'),
  ('2022-02-23','Latifah','Clay','(261) 623-5350','latifahclay5330@protonmail.ca','503-2710 Est, St.','94206','7, 73, 71'),
  ('2022-09-09','Tad','Carney','1-858-506-5132','t_carney9285@hotmail.org','316-4479 Fusce St.','26266','7, 79, 23'),
  ('2021-10-05','Bert','Stephenson','1-931-383-6760','bstephenson1063@aol.org','Ap #881-7173 Lacus. Ave','75712','5, 67, 71, 3, 37, 79'),
  ('2022-01-01','Daquan','Carver','1-622-617-6346','carver_daquan1829@outlook.edu','P.O. Box 346, 7748 Sapien Ave','06696','11');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2020-09-04','Cadman','Kerr','(327) 567-6762','ckerr@outlook.com','2707 Ultricies Av.','27474','41, 5, 71, 37, 31'),
  ('2022-03-18','Vernon','Reid','1-482-643-1733','v_reid@icloud.edu','Ap #505-1406 Neque. Rd.','08911','53, 83, 41'),
  ('2021-11-11','Sebastian','Paul','1-480-218-4821','spaul1800@aol.org','6847 Vestibulum Av.','45131','61, 83, 7, 13, 37, 47'),
  ('2021-06-23','Colt','Lee','1-534-455-3928','c.lee951@hotmail.com','895-9648 Nisi. Road','13846','5, 29'),
  ('2021-11-15','Julie','Bowen','(517) 862-6735','julie_bowen@icloud.net','8005 Eget St.','52016','13, 1, 47, 43'),
  ('2021-08-12','Cade','O''Neill','1-242-143-2762','o.cade9191@yahoo.ca','241-6202 Accumsan Av.','34289','13, 41, 43, 97'),
  ('2020-03-17','Xantha','Nash','(378) 475-7765','x_nash6414@icloud.com','P.O. Box 160, 7575 Ante Street','07546','13, 97, 59, 67, 73'),
  ('2021-02-22','Mechelle','Mathis','(467) 521-5516','m.mechelle8085@aol.org','P.O. Box 997, 987 Dolor. Rd.','78492',''),
  ('2020-11-02','Noel','Thompson','1-870-238-2274','thompson-noel7468@protonmail.edu','531-2843 Vel, Rd.','29176','3, 7, 1, 67, 53, 73'),
  ('2020-01-07','Darryl','Mendoza','(874) 652-4548','darryl.mendoza5906@protonmail.ca','P.O. Box 260, 8433 Sagittis Avenue','88523','');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2021-08-25','Reed','Walters','1-265-322-5438','w-reed@icloud.com','Ap #813-9133 Accumsan Ave','28556','3, 79, 71, 5, 61'),
  ('2021-09-09','Hanna','Bell','1-317-489-4824','hanna-bell@outlook.ca','7570 Non, Road','41835','41, 79, 43, 17'),
  ('2022-09-13','Cheryl','Rasmussen','1-644-326-4714','r_cheryl@icloud.ca','Ap #690-4169 Ultricies Rd.','88857','47, 11'),
  ('2022-10-31','Calvin','Acosta','(315) 685-3353','c.acosta8154@google.net','P.O. Box 479, 6914 Libero Street','28383','1, 43, 11, 47, 5'),
  ('2021-01-17','Danielle','Stone','(322) 404-5268','d.stone@google.edu','P.O. Box 671, 9889 Ipsum Road','27366','47, 3, 41'),
  ('2022-04-22','Vera','Ramirez','(583) 217-5388','r.vera5911@protonmail.org','851-8488 Sodales. Avenue','47323','2, 61, 71, 5'),
  ('2022-07-01','Ila','Chan','1-215-784-8333','ila-chan206@yahoo.net','4681 Montes, Ave','79342','89, 79'),
  ('2021-08-22','Dante','Francis','(258) 732-4264','francisdante1489@yahoo.org','835-3307 Duis Road','75519','61, 3, 2'),
  ('2022-06-23','Martin','Holland','1-948-631-6617','holland.martin@google.ca','851-2118 Amet Av.','45762',''),
  ('2020-01-10','Barrett','Chavez','1-686-690-8886','c_barrett1624@google.com','749-8663 Sed Rd.','81812','41, 23');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2021-06-28','Joshua','Fletcher','1-322-789-7968','f-joshua@icloud.ca','4193 Orci. St.','35866','71, 61, 47, 3, 89'),
  ('2021-10-02','Jonas','Dudley','(516) 586-4747','jonas_dudley@icloud.edu','425-7340 Maecenas Street','82752','41, 89, 7'),
  ('2021-10-22','Darryl','Harding','1-687-260-4535','h_darryl@google.net','P.O. Box 961, 7060 Vulputate Road','19374','29, 3, 17, 67, 47'),
  ('2021-07-11','Prescott','Riley','1-361-794-5555','r.prescott@protonmail.net','133-3095 Vitae St.','77653','97'),
  ('2019-12-19','Addison','Boyer','1-816-279-1353','b-addison@hotmail.ca','109-811 Risus Road','68819','53, 5, 13, 19'),
  ('2020-01-04','Lana','Knox','1-957-636-1346','k-lana@icloud.net','5423 Elit Ave','71873','73'),
  ('2020-03-31','Cora','Duran','1-737-244-3051','c_duran@outlook.net','946-9362 Accumsan Rd.','77264',''),
  ('2022-04-24','Ulric','Ferguson','1-880-311-4434','ulric_ferguson2527@icloud.org','P.O. Box 155, 1537 Parturient St.','47276','37, 43, 19, 13, 67'),
  ('2021-11-17','Lacey','Mccarthy','(127) 876-7616','l-mccarthy1936@aol.org','P.O. Box 412, 6888 Mus. Street','56006','7, 29, 13, 37, 3, 17'),
  ('2022-04-26','Stuart','Rosario','1-458-356-6445','rosariostuart4094@hotmail.net','966-6437 Aenean Road','85548','5, 47, 67, 3');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2022-02-19','Cairo','Carr','(139) 897-5814','carr.cairo@aol.org','992-5159 Donec Rd.','08791','97, 7'),
  ('2020-04-04','Peter','Browning','(532) 651-4326','browning_peter22@hotmail.net','P.O. Box 806, 9403 Tortor St.','64092','59, 37'),
  ('2020-10-28','Noble','Roy','(734) 200-7630','n_roy9066@yahoo.com','Ap #977-4187 Nonummy St.','13956','61, 11, 59, 43'),
  ('2022-03-19','Maxwell','Farley','1-667-504-8222','farleymaxwell@yahoo.edu','Ap #341-1257 Nec Street','08848','7, 3, 37, 13'),
  ('2020-02-05','Hayfa','Juarez','1-748-718-3019','juarez-hayfa9630@icloud.edu','837-5553 Enim. Av.','56433','47, 89, 29, 53'),
  ('2022-02-05','Ezra','Washington','1-549-464-3604','ezra_washington@yahoo.net','Ap #321-9304 Libero. Avenue','11329','83, 47'),
  ('2020-02-29','Barclay','Wilson','1-788-266-3213','b_wilson@yahoo.com','875-4720 Egestas. St.','04945','23'),
  ('2021-04-25','Sonia','Leach','1-643-915-2184','s-leach7911@hotmail.com','1439 Enim Rd.','42211','19, 5, 31'),
  ('2020-12-10','Joseph','Dillon','1-525-650-5882','dillonjoseph@hotmail.edu','138-2909 Vulputate, Ave','42676','11, 37, 61, 67, 23, 43'),
  ('2021-11-27','Joseph','Haney','(428) 543-4622','joseph.haney@outlook.org','P.O. Box 938, 5159 Sit Avenue','17141','61, 37, 1, 29');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2022-09-21','Joel','Pugh','1-876-362-6644','j_pugh@yahoo.edu','824-268 Dis Road','54451','47'),
  ('2021-10-05','Leroy','Marsh','1-792-343-1582','l.marsh8331@aol.ca','P.O. Box 535, 9387 Semper Street','43458','31, 47, 43'),
  ('2022-01-01','Len','Chambers','1-417-145-1481','chamberslen@outlook.net','Ap #916-8689 Amet, Street','39673','3'),
  ('2021-03-26','Kasimir','Paul','1-354-415-9153','kpaul@hotmail.com','P.O. Box 133, 1253 Netus Ave','97336','19, 53, 23, 41, 1'),
  ('2022-08-17','Leandra','Allison','1-377-643-8543','allison_leandra6983@hotmail.ca','701-6457 Blandit. Street','56762','31, 5, 97, 37, 23'),
  ('2020-05-18','Tamekah','Thornton','(772) 122-6427','thornton-tamekah9850@icloud.edu','511-9666 Tempor St.','92191','11, 29'),
  ('2020-12-09','Ima','Beach','(799) 530-3326','beachima9507@icloud.org','101-3198 Sed Rd.','88366','31'),
  ('2020-10-18','Kimberley','Bartlett','(141) 667-1665','bkimberley9875@yahoo.org','Ap #651-8009 In Av.','11937','43, 5'),
  ('2021-10-22','Julian','Jenkins','(298) 138-0385','jjenkins7300@outlook.com','727-5097 Ac Rd.','16472','31, 61, 73'),
  ('2021-05-11','Kirk','Wilder','1-538-465-4746','k-wilder729@google.net','555-4702 Eu Rd.','38204','19, 41, 97, 17');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2020-12-14','Aquila','Ryan','1-623-804-9619','ryan.aquila4594@aol.com','P.O. Box 660, 925 Parturient Avenue','72404','59'),
  ('2021-05-28','Lenore','Harrison','(410) 486-9645','harrison-lenore@aol.net','Ap #957-2876 Mauris St.','66944','71, 67, 61'),
  ('2019-12-19','Germaine','Patel','1-689-801-6534','g.patel@google.ca','P.O. Box 357, 5701 Risus Ave','39372',''),
  ('2021-01-17','Josephine','Erickson','1-786-680-8560','e-josephine1821@google.ca','Ap #742-6041 Sed Av.','35631',''),
  ('2022-08-04','Julie','Pate','1-797-501-5488','patejulie4124@outlook.org','791-5302 Metus. Road','45949','31, 11, 47, 5'),
  ('2020-10-03','Colton','Knox','1-967-122-4713','cknox@icloud.edu','P.O. Box 779, 4193 Ligula Avenue','71323','7, 73, 23, 2, 1'),
  ('2021-03-24','Elaine','Tanner','1-299-112-3652','t-elaine@hotmail.com','Ap #185-2997 Tellus Road','50438',''),
  ('2020-06-22','Rahim','Leonard','1-636-577-1562','rahim_leonard@outlook.edu','Ap #927-5310 Donec St.','11967','71, 41'),
  ('2021-07-13','Cailin','Wilkinson','1-141-652-1311','cailin-wilkinson9511@hotmail.ca','5664 Et Road','32648','1'),
  ('2020-01-03','Robin','Watson','1-209-818-3935','r_watson632@hotmail.ca','6540 Libero Rd.','39051','7, 1, 97');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2021-10-17','Hall','Lloyd','1-878-144-5755','hall_lloyd1440@google.org','641-9776 Quis, Rd.','51284','31'),
  ('2022-05-26','Ann','Chapman','(652) 612-2151','achapman@icloud.edu','392-8481 Lectus. Rd.','67865','29, 61, 71, 7, 1'),
  ('2020-10-20','Lillian','Rivas','1-440-249-5095','rivas_lillian@icloud.edu','109-2049 Vivamus Rd.','32847','2, 41, 47'),
  ('2022-08-03','Quynn','Wade','(833) 341-5472','w-quynn5174@outlook.com','1318 Placerat, Av.','82393','59'),
  ('2021-11-11','Merritt','Jefferson','1-158-627-6532','m-jefferson4823@google.net','Ap #422-9172 Molestie Ave','82864','41'),
  ('2022-12-31','Tara','Quinn','1-241-871-1307','quinntara8416@yahoo.com','P.O. Box 953, 6119 Urna. Road','29674','61, 17, 53, 2'),
  ('2020-12-07','Sage','Delacruz','(236) 406-5502','s_delacruz@icloud.edu','6914 Nunc Ave','34662','67'),
  ('2022-08-04','Nola','Jefferson','1-418-886-3551','jeffersonnola@icloud.net','632-2047 Tellus. Avenue','82734','5, 97'),
  ('2022-12-31','Ethan','Blackburn','1-276-516-2351','blackburn.ethan@outlook.com','Ap #579-8132 Egestas Street','33339','11, 83'),
  ('2022-05-01','Shaeleigh','Maddox','1-318-231-0721','mshaeleigh@google.net','P.O. Box 852, 5446 Elit, St.','60457','61, 79, 37, 11, 73, 13');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2019-12-19','Dalton','Morton','(881) 679-4175','m_dalton7364@yahoo.ca','P.O. Box 272, 3426 Tincidunt, St.','26402','59, 2'),
  ('2021-06-07','Wylie','Parks','1-366-887-5161','wylie_parks4383@icloud.edu','955-2609 Parturient Avenue','37370','43, 1'),
  ('2022-03-26','Leila','Finley','1-739-438-4338','finley.leila5540@hotmail.edu','203-8721 Aliquam Av.','22149','43, 83, 23, 79'),
  ('2021-12-27','Abel','Robbins','1-101-847-7604','r.abel1807@hotmail.ca','7567 Ipsum Avenue','47282',''),
  ('2022-09-02','Bo','Dixon','1-835-384-5404','dixon_bo@icloud.net','3568 In St.','65573','11, 61, 7, 83'),
  ('2020-07-14','Mia','Pruitt','1-756-587-4848','pruittmia9259@google.ca','436-4361 Et Street','28955','19, 41, 67, 37, 97'),
  ('2021-09-04','Kiayada','Wheeler','1-325-224-4946','wheeler.kiayada4410@protonmail.org','Ap #746-4832 Neque Avenue','75177','53, 19, 2, 43'),
  ('2022-06-03','Rhea','Burgess','1-978-658-4274','rhea-burgess@aol.ca','9087 Pede. St.','51882','23, 47, 43'),
  ('2020-04-23','Moana','Garner','(307) 451-3252','mgarner2128@google.ca','Ap #575-6657 Augue St.','22315','2'),
  ('2020-04-27','Lionel','Lester','(365) 751-4613','l_lester9314@icloud.edu','Ap #371-3113 Auctor Rd.','71193','3, 67, 43, 2, 23');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2022-08-21','Noah','Floyd','1-527-431-3337','f-noah2124@aol.com','Ap #574-5732 Nascetur Rd.','68253','89'),
  ('2021-06-09','Dexter','Workman','1-131-363-5207','workman_dexter@icloud.net','4957 Commodo Road','82380','5'),
  ('2020-10-27','Trevor','Stevenson','(502) 220-4342','stevensontrevor@yahoo.ca','Ap #244-1115 Id, Road','38183','29, 37, 71'),
  ('2020-04-16','Robin','Shaffer','(307) 703-5257','shaffer_robin5940@yahoo.edu','P.O. Box 592, 8078 Parturient St.','77441',''),
  ('2022-08-02','Kylie','Stuart','1-590-678-5709','stuart.kylie@hotmail.ca','982-9457 Proin Street','52455','2, 47, 17, 79, 53'),
  ('2021-11-03','Eaton','Yates','1-925-504-5336','e.yates1976@outlook.edu','3511 Libero St.','11364','97, 53'),
  ('2021-12-27','Wyoming','Gillespie','(604) 883-7087','w_gillespie3213@outlook.com','1721 Pede. Street','35278','5, 89, 2, 61, 31'),
  ('2021-07-14','Rowan','Woodard','1-473-365-2573','woodard-rowan5001@yahoo.org','P.O. Box 417, 5617 Placerat St.','67139','41'),
  ('2021-12-22','Dolan','Dillard','1-941-975-4485','ddillard@yahoo.ca','711-5602 Auctor, Av.','52218','19'),
  ('2022-10-30','Tallulah','Brooks','1-417-686-7093','brooks_tallulah5021@aol.org','P.O. Box 566, 8427 Massa. St.','48131','79, 3');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2020-05-20','Davis','Barker','(217) 934-2484','b_davis6305@aol.ca','Ap #533-6720 Adipiscing Road','52128','19, 59'),
  ('2021-12-17','Yael','Mccray','1-614-363-5334','myael@icloud.edu','Ap #550-5770 Morbi Av.','34475','83, 2, 61, 43, 1'),
  ('2020-01-22','Olga','Langley','1-412-548-5793','olangley5484@protonmail.com','3821 Sit St.','40110','53, 19'),
  ('2021-10-21','Alyssa','Diaz','1-685-667-8365','adiaz4244@protonmail.edu','Ap #505-2973 Est St.','16211','47, 19'),
  ('2021-08-19','Vielka','Mcneil','(648) 815-1024','mcneil_vielka9805@outlook.net','756-2306 Felis St.','40815','53, 73, 41'),
  ('2020-11-12','Rigel','Riley','1-351-555-7607','r_riley@outlook.edu','Ap #733-3033 Sollicitudin Road','63727','59, 1, 89'),
  ('2021-06-13','Genevieve','Yang','(429) 359-5376','genevieve.yang3503@icloud.edu','2081 Erat Rd.','87225','2, 31, 47, 29, 79'),
  ('2020-12-10','Jeanette','Hartman','(487) 632-1383','jhartman@google.net','Ap #972-9788 Est Street','05786','7, 17'),
  ('2022-06-05','Kennedy','Barrera','1-594-874-1453','barrera.kennedy9569@icloud.edu','P.O. Box 724, 8616 Dis Ave','74743',''),
  ('2019-12-24','Calista','Fulton','(641) 132-7889','fultoncalista@outlook.com','Ap #367-9844 Nunc St.','97162','67, 1, 71, 43');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2022-07-31','Debra','Murphy','1-411-813-5444','debra-murphy8416@google.org','Ap #840-290 Interdum Rd.','78854','23, 89, 11'),
  ('2020-10-15','Karleigh','Mercer','(741) 135-3002','mercerkarleigh@outlook.edu','Ap #409-8904 At, Road','13451',''),
  ('2022-01-29','Grant','Macias','(821) 849-0884','g.macias@yahoo.com','Ap #736-8582 Donec Ave','23778','67'),
  ('2020-07-11','Hedwig','Colon','(122) 625-7127','hedwig-colon@hotmail.com','127-4725 Purus, Av.','35641','5'),
  ('2020-02-28','Cadman','Workman','(736) 643-4434','workman-cadman6602@protonmail.org','Ap #783-4270 Semper, Rd.','20680','73, 3, 31, 97, 83'),
  ('2021-04-10','Nathaniel','Glass','(747) 803-2714','g_nathaniel@hotmail.com','699-8192 Dui. Road','68741','29, 79, 19, 31, 11, 59'),
  ('2021-07-29','Fatima','Glass','1-565-941-8134','glass_fatima2626@google.net','6074 Rutrum. Ave','32866','89, 53, 97, 67'),
  ('2022-04-03','Leonard','Schultz','(695) 242-8235','l-schultz5749@aol.edu','917-7437 Gravida Street','57415','41'),
  ('2022-09-28','Daryl','Humphrey','1-636-518-1735','d.humphrey@aol.net','P.O. Box 164, 7886 Sit Ave','82199','41, 17, 3'),
  ('2021-10-28','Alfreda','Petersen','1-563-261-5691','a_petersen7485@outlook.net','362-2536 A, St.','30923','23, 61, 67, 31, 83');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2022-07-31','Cally','Schneider','(724) 512-8656','cschneider823@hotmail.ca','Ap #454-9226 Vel Road','83727','47, 89, 13'),
  ('2020-08-22','Amena','Wood','1-753-830-8685','a-wood@google.net','Ap #920-489 Non Road','65414','17, 13, 73'),
  ('2022-05-31','Mary','Clark','(670) 686-3197','clarkmary9405@hotmail.net','Ap #833-3855 Nulla. Street','44637','2'),
  ('2021-03-29','Berk','Bradshaw','1-453-420-3411','bradshawberk4138@protonmail.ca','276-2321 Maecenas Road','42847','83, 89, 97, 7, 5, 2'),
  ('2020-04-04','Alec','Gay','1-781-422-3763','alec-gay3331@protonmail.com','Ap #562-1174 Lectus St.','38132','13'),
  ('2020-01-08','Emma','Mooney','1-764-175-5676','emooney4394@google.edu','3340 Non Rd.','77174','13, 53, 1, 5, 37, 3'),
  ('2020-07-06','Vivian','Moses','(892) 755-1465','moses-vivian@icloud.ca','906-3988 Vel, St.','38940','73, 13, 2, 31, 89'),
  ('2021-04-05','Aline','Hurley','1-304-662-9463','aline_hurley5404@google.edu','Ap #635-3372 Cubilia Av.','56813','37, 73, 97, 43'),
  ('2021-10-10','Virginia','Holmes','1-251-438-7322','v_holmes490@icloud.com','247 Non, Rd.','88060','71, 41, 53, 47, 59, 83'),
  ('2022-05-01','Dora','Perkins','(866) 659-4722','perkins-dora2589@protonmail.net','614-745 Velit. St.','85168','7, 43, 5, 83, 59, 41');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2020-12-24','Alika','Kirkland','1-612-251-3518','a-kirkland@icloud.edu','6200 Cras Avenue','02746','23, 37, 1'),
  ('2022-10-08','Gay','Harrell','1-610-374-7780','gay-harrell8039@icloud.net','Ap #796-8434 Eu, Street','70160','43, 53, 17, 2, 41'),
  ('2021-07-16','Kylee','Kinney','(319) 736-3439','k-kylee@aol.edu','145-467 Risus, Avenue','61846','73, 71, 5, 53, 19, 79'),
  ('2022-02-18','Thane','Whitaker','(148) 485-2136','whitaker.thane@aol.edu','3746 Et Street','14153','13, 41, 97, 83'),
  ('2021-01-29','Tashya','Burnett','(666) 521-6262','t-burnett@outlook.edu','5721 Urna. Rd.','34247','29, 67, 73, 37, 7'),
  ('2022-04-21','Amelia','Mcfadden','(298) 523-7731','a_mcfadden@yahoo.com','Ap #633-5185 Enim Ave','09365','1'),
  ('2021-03-06','Stella','Hoover','1-388-440-6382','shoover@yahoo.ca','Ap #153-4332 Morbi Av.','66175','59, 17, 67'),
  ('2022-03-27','Althea','Beasley','1-419-573-8138','balthea9904@outlook.com','7462 Mauris, Rd.','74128','5, 19, 31'),
  ('2022-05-07','Lael','Mason','1-938-360-6724','masonlael@outlook.org','514-808 Suspendisse Ave','86249','89, 3, 17, 97, 53'),
  ('2021-11-19','Tobias','Floyd','1-996-889-1582','tobiasfloyd@google.net','499-3484 Dolor Street','98125','47, 19, 31, 79, 61');
INSERT INTO readyset_sample (createdOn,firstName,lastName,phone,email,address,postalZip,luckyNumbers)
VALUES
  ('2020-12-10','Laith','Casey','1-888-266-2428','c-laith1951@icloud.com','Ap #752-6435 Congue, Ave','95096','43, 5, 89, 71, 7'),
  ('2022-04-22','Moana','Moon','1-703-376-8443','moon-moana@protonmail.edu','371-2333 Vehicula Avenue','38618','71, 29, 79, 61, 31'),
  ('2022-10-31','Deirdre','Goodwin','1-711-505-6188','d-goodwin8253@hotmail.org','P.O. Box 208, 1116 Ipsum Avenue','52333','37, 17, 23, 13, 29'),
  ('2022-02-09','Wesley','Soto','1-914-997-4443','sotowesley@aol.edu','573-5296 Molestie St.','13065','2, 67, 41, 79, 7'),
  ('2021-05-06','Keegan','Le','1-361-453-3417','le-keegan@icloud.ca','203-8529 Nec Street','16730','83, 23, 73'),
  ('2021-11-21','Berk','Petty','1-235-211-2475','berk_petty@outlook.net','P.O. Box 799, 4932 Nec St.','63566','19, 17'),
  ('2020-08-24','Eugenia','Fuller','(148) 945-8773','f.eugenia2482@google.com','Ap #142-4627 Maecenas Road','95124','2, 47, 5, 41, 37'),
  ('2022-02-24','Gavin','Weeks','(232) 772-4554','wgavin@outlook.net','6623 Est, Rd.','22724','29, 53, 43, 79, 89, 1'),
  ('2020-07-30','Piper','Jordan','1-975-361-9427','jordan-piper@outlook.ca','191-898 Volutpat. Ave','01554','3, 61'),
  ('2022-06-30','Gray','Warren','(971) 401-4169','g.warren6371@protonmail.net','P.O. Box 382, 5428 Nunc. Street','98854','13, 67, 73, 79');
