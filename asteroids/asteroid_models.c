// This file contains data generated by tools.js.
// Generally these things are here because we don't have stdlib or libc
// available, which means we don't get math.h. So no sin()/cos().

// We're doing this instead of randomly generating them because
// we want to audition them, and only accept the best.

// We have 12 asteroid models.
// Each asteroid contains 10 points.
// The points range from -0.5 to + 0.5.
// There are 12 asteroids * 10 points * 2 values per point = 240.
int asteroid_model_count = 12;
double asteroid_models[240] = 
{
// Model 0
0.43902539258832174, 0.10796716250061396,
0.44265626954505705, 0.23061585475933033,
0.15572388095853282, 0.5053920905603786,
-0.1559008950579007, 0.4509599392989266,
-0.34399445902111475, 0.3374119940991772,
-0.5500465021691935, -0.10001297603504654,
-0.39292731348702137, -0.41718995832375294,
-0.15880882943802876, -0.37960788607269,
0.04885362439815692, -0.548554685863479,
0.3585812568160655, -0.29771704850241515,

// Model 1
0.4579247151834371, 0.10419687713638352,
0.38250417260138714, 0.19114092899351304,
0.2197472560238903, 0.35298435047658994,
-0.04697622252490798, 0.46701152891732844,
-0.5202617623157818, 0.2825576674480481,
-0.4671139848278331, 0.10061208781561161,
-0.3461158446471662, -0.30700086261783927,
-0.27392418359006443, -0.48039419918006465,
0.27121764457559655, -0.4522001897156862,
0.3829309430583172, -0.17235030571390758,

// Model 2
0.5137787044189557, -0.07364642490066006,
0.4299515270907574, 0.20716025006501967,
0.20366813387719568, 0.49942877855443013,
-0.2634310834620256, 0.4950765121291058,
-0.38976007378820837, 0.283875744128421,
-0.49458283347458204, 0.04325638334764172,
-0.35627220046628555, -0.1840101296110128,
-0.14243023831162346, -0.3889776814569948,
0.12742721419707476, -0.49553791475996806,
0.4913314070455728, -0.20057588944357466,

// Model 3
0.47049802348266045, -0.08467622186538756,
0.48826748815214066, 0.3249718844089661,
0.18775303759766007, 0.36841038490705347,
-0.19168759274863, 0.38715666520555814,
-0.49433161094435685, 0.29754143194672145,
-0.5666520244025456, -0.003752663659040837,
-0.35221576890550393, -0.357450737766279,
-0.20889356507443152, -0.46695887676322895,
0.1135930173295115, -0.49648367349944555,
0.3107083431428373, -0.3615096851201749,

// Model 4
0.5448338473850575, -0.013900983309582999,
0.2882508831190851, 0.34096220050087134,
0.23367087646701912, 0.4517926416395606,
-0.11572217184255464, 0.43205503134108975,
-0.4665251868865298, 0.278161997836755,
-0.4038120099748582, 0.008963941373667761,
-0.3744469212721079, -0.2962630351824776,
-0.18312065565148755, -0.4893812511110508,
0.2852205436083439, -0.4614742487263238,
0.43421067864886714, -0.2591555243552971,

// Model 5
0.4930022864192415, 0.11605422181671839,
0.3573783401511714, 0.3275291148814763,
0.0989147831740741, 0.47516192057064965,
-0.12023423557459276, 0.48393682128492194,
-0.4345221455573633, 0.3802649149095673,
-0.4973720751978335, 0.013906863224038911,
-0.3623066692313079, -0.21962528735371975,
-0.13435469058481264, -0.3855129237307491,
0.06150502266049606, -0.5792408568847347,
0.4281542232187329, -0.3889699545559119,

// Model 6
0.431542626548609, 0.019620795712377598,
0.4955515156809552, 0.2802242824714487,
0.1294090608223965, 0.4914493326452858,
-0.15135251992979618, 0.468514577106317,
-0.5002165515030743, 0.2750084263546417,
-0.4796142163269895, -0.016215380705158267,
-0.32593241720193433, -0.3065734711541074,
-0.1209694585410297, -0.43206180422794127,
0.21559531269487625, -0.46844715120236047,
0.35714635367850417, -0.33452135707372455,

// Model 7
0.5542520588193262, -0.004321014337154644,
0.38499552150405875, 0.34245000580852863,
0.12141400155166983, 0.5848452206554382,
-0.24071621150417488, 0.4645621597627371,
-0.3766870708551396, 0.19938343495738875,
-0.5762123904161349, 0.1304065125414072,
-0.3993190302993188, -0.29314519121705007,
-0.2067786876865788, -0.38746321550159807,
0.12211883329949838, -0.38209369187783976,
0.37156168319712723, -0.32165337933609356,

// Model 8
0.4495389741698698, 0.0886645437356909,
0.37560934245642474, 0.2236768210460372,
0.041840126227169164, 0.4183028584746292,
-0.08389577705402311, 0.48619290576929997,
-0.36757111207124604, 0.3094932696061835,
-0.5582503024893722, 0.07384968427346238,
-0.5149715645431471, -0.29935676871825334,
-0.08694540889635326, -0.40220327431740865,
0.0336075818597832, -0.49636673619232247,
0.43654781055691155, -0.2735307526906313,

// Model 9
0.5652687099734235, -0.0835356396886248,
0.48802726336601804, 0.27711614157721376,
0.19115544705131818, 0.5240597259501991,
-0.0963390961258919, 0.39889925904140555,
-0.2607849748338221, 0.3127746959632822,
-0.525750360262038, -0.08285472824797295,
-0.39062135562847594, -0.32928980819538584,
-0.07650760893551532, -0.4006918957663347,
0.2073336756300284, -0.5121144089694147,
0.3419393474294713, -0.3405511025053864,

// Model 10
0.5836244577111559, 0.01361926478613589,
0.35819283387067696, 0.2893438008859369,
0.2121215707318726, 0.4041033495619883,
-0.2503157804698008, 0.5287835680213533,
-0.32093251735195166, 0.24937846275951298,
-0.4939450802750494, -0.016071585457346212,
-0.4034038824072765, -0.31836526268145404,
-0.08068219638518732, -0.47599587840758645,
0.19359480554113084, -0.5371155839165589,
0.4408493009972612, -0.24022115003172326,

// Model 11
0.4479861656246969, -0.06880578473358297,
0.3802370885622502, 0.31373427131856835,
0.10207561550017283, 0.5301853454223452,
-0.2102801954112252, 0.4385506463919093,
-0.4431150537795006, 0.2647249921778356,
-0.5042413056523688, -0.01786537298887376,
-0.3208649667441609, -0.2984840071488262,
-0.22874427974495393, -0.5487331774611215,
0.12602700964353536, -0.4657586866417139,
0.4617283529133857, -0.2523911283239903
};
