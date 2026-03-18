import QtQuick
import QtQuick.Controls
import QtQuick.Shapes

Rectangle {
    id: element15
    width: 259
    height: 1080
    color: "#191919"
    radius: 10
    clip: true
    property alias fitness_FreedomText: fitness_Freedom.text
    state: "property_1_Default"

    Minimize_1 {
        id: minimize
        width: 211
        height: 70
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 24
        anchors.topMargin: 980
        state: "property_1_Default"
        clip: true
    }

    Nutrition {
        id: nutrition
        width: 211
        height: 70
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 24
        anchors.topMargin: 235
        state: "property_1_Default"
        clip: true
    }

    Workout {
        id: workout
        width: 211
        height: 70
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 24
        anchors.topMargin: 340
        state: "property_1_Default"
        clip: true
    }

    Rectangle {
        id: title
        width: parent.width - 21
        height: 75
        color: "transparent"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 21
        anchors.topMargin: 10
        Text {
            id: fitness_Freedom
            width: 133
            height: 65
            color: "#4895dd"
            text: qsTr("Fitness Freedom")
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 85
            anchors.topMargin: 5
            font.pixelSize: 32
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
            styleColor: "#000000"
            style: Text.Outline
            font.weight: Font.Normal
            font.family: "PoetsenOne"
        }

        Rectangle {
            id: shoe
            width: 75
            height: 75
            color: "#ffffff"
            radius: 10
            anchors.left: parent.left
            anchors.top: parent.top
            Shape {
                id: element
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 11
                anchors.rightMargin: 47
                anchors.topMargin: 18
                anchors.bottomMargin: 46
                layer.samples: 16
                layer.enabled: true
                ShapePath {
                    id: vector_ShapePath_0
                    strokeWidth: 0.125
                    strokeColor: "transparent"
                    PathSvg {
                        id: vector_PathSvg_0
                        path: "M 7.495180349791407 11.020833969116211 C 7.143617831519656 11.020833969116211 6.786959783959889 11.015624045521896 6.415016818842958 10.994790711302134 C 4.438114477044649 10.911457374423085 2.8892013671490355 10.229168254415033 1.809038322108044 8.979168123619077 C -0.13219816938046458 6.729167888186357 -0.015010610460098927 3.276041331665149 0.01046493480984378 2.796874625208062 L 0.02575012663899028 2.749999542692994 C 0.14293763526034192 2.3385411714800064 0.4894053834744787 1.0781252835539947 1.5033320749685881 0.531250272896896 C 2.1656962178217305 0.1718752508151027 2.7618238249126943 0 3.3222858246475857 0 C 4.050886381786042 0 4.723441279523056 0.2916653519419168 5.380710318257207 0.8958320404345115 C 7.0570011526044585 2.437498827024073 8.937095301373297 3.3958337921426387 10.28220412503241 3.3958337921426387 C 11.245179714598176 3.3958337921426387 13.818209784964315 3.2447910800425475 14.867802205291362 3.1770827447984478 L 16.457475662231445 8.536456582639232 C 15.652448421831261 9.177081634150115 12.880710384116256 11.020833969116211 7.495180349791407 11.020833969116211 Z"
                    }
                    fillRule: ShapePath.WindingFill
                    fillColor: "#37474f"
                }
                antialiasing: true
            }

            Shape {
                id: element1
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 11
                anchors.rightMargin: 46
                anchors.topMargin: 18
                anchors.bottomMargin: 45
                layer.samples: 16
                layer.enabled: true
                ShapePath {
                    id: vector_ShapePath_1
                    strokeWidth: 0.125
                    strokeColor: "transparent"
                    PathSvg {
                        id: vector_PathSvg_1
                        path: "M 3.8901932368633227 1.161460043851527 C 4.471035676397327 1.161460043851527 5.0213079151588955 1.4062498858336907 5.566484624427842 1.9062498583487277 C 7.370153255651248 3.5677081672906272 9.34705458353828 4.5572915180160845 10.850111816716742 4.5572915180160845 C 11.706090132677792 4.5572915180160845 13.805275361314736 4.437500411877244 15.023006509418993 4.364583747278546 L 16.363021740488463 8.895832010020253 C 15.343999903957556 9.604165327699619 12.735303088932378 11.015627422240305 8.068183155366022 11.015627422240305 C 7.721715727301207 11.015627422240305 7.36505824243532 11.010418611890469 7.013495710046926 10.994793612749374 C 5.199636870176361 10.916668612193261 3.788291211130162 10.307291931475003 2.8151253742499076 9.182291923466979 C 1.0827882035566185 7.177083705210437 1.1235488919933985 4.072917554545026 1.1490244382862864 3.47395925316626 C 1.250926623457838 3.104167609737397 1.5515381657565648 2.0468763649878436 2.3412800647726435 1.6250013775068772 C 2.9119322956594886 1.3125013752824262 3.421443183555725 1.161460043851527 3.8901932368633227 1.161460043851527 Z M 3.8901932368633227 0 C 3.1564974854066215 0 2.453372724322006 0.25000077788168107 1.80119876351945 0.5989591085249707 C 0.45099478152525085 1.3281257389899102 0.09433714481327693 3.031250378584151 0.017910504036537194 3.276042036645276 C 0.017910504036537194 3.276042036645276 -0.7004997674187301 11.828124696144416 6.9625444238573895 12.156249682958046 C 7.344677612556479 12.17187468209914 7.711525518654048 12.182292938232424 8.068183155366022 12.182292938232424 C 14.916009683054426 12.182292938232424 17.67755889892578 9.317709698336598 17.67755889892578 9.317709698336598 L 15.853509850408056 3.151043153342549 C 15.853509850408056 3.151043153342549 12.0423674432031 3.3958334609859846 10.855207042517192 3.3958334609859846 C 9.668046641831284 3.3958334609859846 7.920425008505339 2.5052082218156633 6.330751001826022 1.0416666326893906 C 5.500248207482871 0.28645829915431453 4.6799351358794015 0 3.8901932368633227 0 Z"
                    }
                    fillRule: ShapePath.WindingFill
                    fillColor: "#90a4ae"
                }
                antialiasing: true
            }

            Shape {
                id: element2
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 9
                anchors.rightMargin: 6
                anchors.topMargin: 38
                anchors.bottomMargin: 18
                layer.samples: 16
                layer.enabled: true
                ShapePath {
                    id: vector_ShapePath_2
                    strokeWidth: 0.125
                    strokeColor: "transparent"
                    PathSvg {
                        id: vector_PathSvg_2
                        path: "M 0.6950342072572356 0.5061124969394241 C -0.07432719380862662 3.120695767156658 0.002099581074369195 7.73527755500553 0.002099581074369195 7.73527755500553 C 0.002099581074369195 8.46965252268327 0.4555642076769222 9.750903820341769 1.5051565601154364 10.157153797177271 C 7.018063962312353 12.276945510133231 13.300333130005704 11.719652151102775 16.581583128800276 13.25611047801901 C 20.39272440760354 15.042568809784223 32.7432674120191 20.537360339848686 43.07614810104974 19.375902020205913 C 55.37574006757095 17.995693665276203 59.278593943445195 12.31861238456863 59.94605314724549 10.735279103309338 C 60.41989825520118 9.599862424968265 60.74088760735219 5.297778718447332 60.261947395607066 5.136320387156382 C 55.03436580561852 3.3550703836515092 35.535387689981604 11.261321375190693 31.968811636024945 8.506113117767953 C 28.906651221652947 6.141529852399695 1.4643956083230978 -2.10847077327781 0.6950342072572356 0.5061124969394241 Z"
                    }
                    fillRule: ShapePath.WindingFill
                    fillColor: "#e0e0e0"
                }
                antialiasing: true
            }

            Shape {
                id: element3
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 8
                anchors.rightMargin: 6
                anchors.topMargin: 17
                anchors.bottomMargin: 21
                layer.samples: 16
                layer.enabled: true
                ShapePath {
                    id: vector_ShapePath_3
                    strokeWidth: 0.125
                    strokeColor: "transparent"
                    PathSvg {
                        id: vector_PathSvg_3
                        path: "M 4.294740975235475 1.849024578988053 C 4.294740975235475 1.849024578988053 1.3956240049288549 4.156315734207677 0.6466430036718067 8.989648824747348 C -0.153289097262167 14.099023933658103 -0.8615090244146999 21.572984292114977 2.7458279337828824 24.500067503032803 C 5.410569821280272 26.661525839654985 13.63917074879696 25.61465061873374 17.450312105702245 27.401108948501705 C 21.26145346260753 29.18756727826967 32.81716099859065 38.08860634987924 43.15004189937383 36.93235635978949 C 55.44963411795156 35.55214800640284 59.785570447062206 30.083399738046523 60.44793456064695 28.494858130302873 C 60.921779678313186 27.359441453231188 62.23631639181874 25.34381593520645 55.291683103274465 22.48444111577368 C 50.176193934775085 20.38027451412752 46.27334119368795 17.26048104679479 42.70166984127045 14.500064340021497 C 39.639509364145354 12.135481077296827 28.578029699833404 5.250065412714208 28.578029699833404 5.250065412714208 C 28.578029699833404 5.250065412714208 26.728505407166825 0.7604817230979088 23.65615472225403 0.05735672576829391 C 21.638491636659836 -0.40618492350087604 17.14969988267339 2.026106870407233 16.354862946371693 4.244856942005438 C 15.473409122397696 6.708398565742264 16.568858524681964 8.979231919885635 16.568858524681964 8.979231919885635 C 11.810026871705778 11.52089859161655 10.169401717210176 11.901105684961877 6.939102690111183 9.791730630884862 C 3.708803663012191 7.682355576807847 4.294740975235475 1.849024578988053 4.294740975235475 1.849024578988053 Z"
                    }
                    fillRule: ShapePath.WindingFill
                    fillColor: "#0277bd"
                }
                antialiasing: true
            }

            Shape {
                id: element4
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 8
                anchors.rightMargin: 6
                anchors.topMargin: 17
                anchors.bottomMargin: 21
                layer.samples: 16
                layer.enabled: true
                ShapePath {
                    id: vector_ShapePath_4
                    strokeWidth: 0.125
                    strokeColor: "transparent"
                    PathSvg {
                        id: vector_PathSvg_4
                        path: "M 4.294740975235475 1.849024578988053 C 4.294740975235475 1.849024578988053 1.3956240049288549 4.156315734207677 0.6466430036718067 8.989648824747348 C -0.153289097262167 14.099023933658103 -0.8615090244146999 21.572984292114977 2.7458279337828824 24.500067503032803 C 5.410569821280272 26.661525839654985 13.63917074879696 25.61465061873374 17.450312105702245 27.401108948501705 C 21.26145346260753 29.18756727826967 32.81716099859065 38.08860634987924 43.15004189937383 36.93235635978949 C 55.44963411795156 35.55214800640284 59.785570447062206 30.083399738046523 60.44793456064695 28.494858130302873 C 60.921779678313186 27.359441453231188 62.23631639181874 25.34381593520645 55.291683103274465 22.48444111577368 C 50.176193934775085 20.38027451412752 46.27334119368795 17.26048104679479 42.70166984127045 14.500064340021497 C 39.639509364145354 12.135481077296827 28.578029699833404 5.250065412714208 28.578029699833404 5.250065412714208 C 28.578029699833404 5.250065412714208 26.728505407166825 0.7604817230979088 23.65615472225403 0.05735672576829391 C 21.638491636659836 -0.40618492350087604 17.14969988267339 2.026106870407233 16.354862946371693 4.244856942005438 C 15.473409122397696 6.708398565742264 16.568858524681964 8.979231919885635 16.568858524681964 8.979231919885635 C 11.810026871705778 11.52089859161655 10.169401717210176 11.901105684961877 6.939102690111183 9.791730630884862 C 3.708803663012191 7.682355576807847 4.294740975235475 1.849024578988053 4.294740975235475 1.849024578988053 Z"
                    }
                    fillRule: ShapePath.WindingFill
                    fillColor: "#0277bd"
                }
                antialiasing: true
            }

            Shape {
                id: element5
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 24
                anchors.rightMargin: 41
                anchors.topMargin: 17
                anchors.bottomMargin: 49
                layer.samples: 16
                layer.enabled: true
                ShapePath {
                    id: vector_ShapePath_5
                    strokeWidth: 0.125
                    strokeColor: "transparent"
                    PathSvg {
                        id: vector_PathSvg_5
                        path: "M 1.13313657325949 8.964495145094965 C 2.3559626656903254 8.75616182521471 3.3546027394941653 8.73012134960612 4.567238624611148 8.886371343396823 C 4.618189710530382 7.631163065118866 4.027157515500112 6.204078350121262 3.395364054656989 5.151995110337342 C 3.2425107931031345 4.896786792319877 3.069278119105615 4.646787702533171 2.972471058516376 4.365537713709908 C 2.4629602069163368 2.8967878652095616 5.183746774483493 1.3863712068259735 6.269004946700465 1.0634545633398844 C 7.46126029571289 0.7040795931433121 8.760514522196711 0.7613717283685002 9.922199249267578 1.2144966948394935 C 9.31078620305216 0.6832467469951911 8.61275578728473 0.2665791138240136 7.838299302570819 0.08428746474955608 C 5.963299334669156 -0.3480041588679825 3.578789001074867 0.9697034184343791 2.1266831226054967 2.0530366259323554 C -0.12535488033926923 3.724911512926739 -0.5533451667201679 6.23012160417531 0.6745760293675938 8.803038096159337 C 0.7051466797802888 8.870746421627961 0.7459086383908191 8.943662052534432 0.8070499392162093 8.974912049352318 C 0.8732863474946773 9.011370379943312 0.9548073834366244 9.00095395201861 1.0312340142135517 8.985328953609669 C 1.0567095571731688 8.974912288003706 1.0923757060425632 8.969703477897946 1.13313657325949 8.964495145094965 Z"
                    }
                    fillRule: ShapePath.WindingFill
                    fillColor: "#bdbdbd"
                }
                antialiasing: true
            }

            Shape {
                id: element6
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 37
                anchors.rightMargin: 11
                anchors.topMargin: 32
                anchors.bottomMargin: 28
                layer.samples: 16
                layer.enabled: true
                ShapePath {
                    id: vector_ShapePath_6
                    strokeWidth: 0.125
                    strokeColor: "transparent"
                    PathSvg {
                        id: vector_PathSvg_6
                        path: "M 15.91496731370367 0.46056771647477673 C 15.364695604868693 0.043901054864340316 14.656475570595163 -0.11756076004408973 14.004301733949694 0.09077257076112848 C 13.861638703387346 0.13764757135645575 13.718974746564047 0.18973248342558374 13.581406819355303 0.24702414823286556 C 12.348390593014813 0.7678574674848898 11.370130809861376 1.7522307880841315 10.437725985075604 2.7313974257944102 C 9.505321160289832 3.7053557352792224 8.562723942213621 4.720982222772016 7.370468664178804 5.325148855719677 C 5.7553193218875185 6.14285719426415 4.38473700567558 5.741815191367221 2.7746827667378975 5.658481862149542 C 1.3021964398243537 5.585565197143818 0.38507497387755146 6.366814873342026 0.05389295220121343 7.944939815774498 C -0.1753869112954215 9.04389806475868 0.3443159767937175 10.528275644747723 1.281815904933094 11.116817293018983 C 4.496829157978009 13.13765063132148 7.645605217088158 14.038692687134693 11.1408495190118 14.523067677764367 C 15.614354393688377 15.142859357476597 20.291665103184936 14.095981534691264 24.102806055985685 11.627231720645955 C 25.18296893876438 10.929315055463555 26.26312914905246 10.012649722398614 26.52807476639353 8.73139973717042 C 26.52807476639353 8.726191404094315 26.53317096303875 8.7157742606393 26.53317096303875 8.710565927563195 C 26.73188017604455 7.720982633401983 26.1765155504392 6.720981844599542 25.269586303159866 6.3095235112145724 C 21.65205952074974 4.674106834125626 18.64594538372572 2.5439009934828736 15.91496731370367 0.46056771647477673 Z"
                    }
                    fillRule: ShapePath.WindingFill
                    fillColor: "#03a9f4"
                }
                antialiasing: true
            }

            Shape {
                id: element7
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 10
                anchors.rightMargin: 22
                anchors.topMargin: 28
                anchors.bottomMargin: 36
                layer.samples: 16
                layer.enabled: true
                ShapePath {
                    id: vector_ShapePath_7
                    strokeWidth: 0.125
                    strokeColor: "transparent"
                    PathSvg {
                        id: vector_PathSvg_7
                        path: "M 33.34239629568018 11.49999713897705 C 32.09918960506047 11.49999713897705 30.866171665536744 10.932288656236178 29.668821036076928 10.234371962538658 C 27.74796485164587 9.114580230724398 20.01868380980801 3.9166667108662603 17.68512380379908 2.3437500323938374 C 17.1450422505137 3.005208364935324 16.233017225016766 3.9687478221628814 15.163044327264455 4.416664502470951 C 14.15421268242285 4.8385395095436055 13.318614951925525 4.744791258513434 12.57982408372661 4.666666254329231 C 11.841033215527695 4.588541250145028 11.255095722559286 4.520832933881443 10.460258705858891 4.927082924595213 C 9.395380912515806 5.473957907318506 8.447691249446134 6.234372865894558 7.372623247284599 6.760414534864788 C 6.226223661917036 7.322914564991051 4.11175302402793 7.255207009307579 3.0315899174571688 6.838540330673191 C 0.5146059097623823 5.869790309833157 0.12737773170750696 4.499999247599344 0 3.958332593314317 C 1.2381115862104917 4.8541659539304565 2.8481660372481823 5.828125560494249 4.646739594380956 5.750000556310046 C 7.3114817514201516 5.635417222013896 8.27955328984918 4.124997178605477 9.711278965087109 3.390622185840096 C 10.944295446888376 2.7604138239282046 11.948031683628576 2.86979186434552 12.758154074295083 2.958333533167276 C 13.400137837241843 3.0260418649529046 13.909648521118127 3.0833324222748963 14.531251866427986 2.8229157520089143 C 15.509512824075802 2.416665761295144 16.4979625024504 1.1562492237358786 16.79857393591766 0.7031242149895431 L 17.262230745217728 0 L 17.955163973057417 0.4687468275643355 C 18.057066159941883 0.5416634955492513 28.3288057824826 7.473957766081417 30.499322447396317 8.739582818343466 C 31.691577972446908 9.437499512040986 33.2048293269692 10.223955926543852 34.52955768813652 9.43749758730764 C 36.04280515539893 8.5416642266915 37.275819693570256 7.093747182384767 38.651499220306704 5.994788888499915 C 39.34443408808416 5.4374971868119175 40.08832285466033 4.911457923758372 40.93920608060064 4.666666254329231 C 41.79008930654095 4.427082913338356 42.77853852937727 4.526038716704637 43.44090270996094 5.119788717460494 C 40.69973386530649 5.281247054267166 38.447694800983946 7.77083074859374 36.7408332446941 9.734372432465136 C 35.62500428578189 11.020830798480247 34.48370077663852 11.49999713897705 33.34239629568018 11.49999713897705 Z"
                    }
                    fillRule: ShapePath.WindingFill
                    fillColor: "#004a7c"
                }
                antialiasing: true
            }

            Shape {
                id: element8
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 34
                anchors.rightMargin: 33
                anchors.topMargin: 22
                anchors.bottomMargin: 43
                layer.samples: 16
                layer.enabled: true
                ShapePath {
                    id: vector_ShapePath_8
                    strokeWidth: 0.41862
                    strokeStyle: ShapePath.SolidLine
                    strokeColor: "#9e9e9e"
                    PathSvg {
                        id: vector_PathSvg_8
                        path: "M 3.9232338309457355 10.083333015441895 C 4.718070706968294 7.218749862728691 6.669496929518872 4.8906254913277785 7.9432740211486825 2.9427089425157464 M 0 7.354167633476917 C 0.01019021650526939 4.479167824687954 2.8125002034002353 0.4374999587549832 3.2863452851308304 0"
                    }
                    joinStyle: ShapePath.MiterJoin
                    fillRule: ShapePath.WindingFill
                    fillColor: "transparent"
                }
                antialiasing: true
            }

            Shape {
                id: element9
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 30
                anchors.rightMargin: 33
                anchors.topMargin: 22
                anchors.bottomMargin: 45
                layer.samples: 16
                layer.enabled: true
                ShapePath {
                    id: vector_ShapePath_9
                    strokeWidth: 0.41862
                    strokeStyle: ShapePath.SolidLine
                    strokeColor: "#e0e0e0"
                    PathSvg {
                        id: vector_PathSvg_9
                        path: "M 0 5.32291548344053 C 2.6494564158775575 2.6979154205518863 6.165080845566207 0.3229166793306009 7.912703156462904 0 M 4.626357669807955 7.562500476837158 C 6.791778858365827 5.208333745886145 9.604278110572288 3.4843749533876816 12.656248092651365 2.6406249243037356"
                    }
                    joinStyle: ShapePath.MiterJoin
                    fillRule: ShapePath.WindingFill
                    fillColor: "transparent"
                }
                antialiasing: true
            }

            Shape {
                id: element10
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 42
                anchors.rightMargin: 29
                anchors.topMargin: 28
                anchors.bottomMargin: 41
                layer.samples: 16
                layer.enabled: true
                ShapePath {
                    id: vector_ShapePath_10
                    strokeWidth: 0.41862
                    strokeStyle: ShapePath.SolidLine
                    strokeColor: "#9e9e9e"
                    PathSvg {
                        id: vector_PathSvg_10
                        path: "M 0 6.515622138977052 C 0.7489809995410505 4.296872019767762 2.175611301318968 1.9218750298023226 3.4748640060424805 0"
                    }
                    joinStyle: ShapePath.MiterJoin
                    fillRule: ShapePath.WindingFill
                    fillColor: "transparent"
                }
                antialiasing: true
            }

            Shape {
                id: element11
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 38
                anchors.rightMargin: 29
                anchors.topMargin: 28
                anchors.bottomMargin: 43
                layer.samples: 16
                layer.enabled: true
                ShapePath {
                    id: vector_ShapePath_11
                    strokeWidth: 0.41862
                    strokeStyle: ShapePath.SolidLine
                    strokeColor: "#e0e0e0"
                    PathSvg {
                        id: vector_PathSvg_11
                        path: "M 0 4.791664123535156 C 2.2365687636320772 2.4208225458792927 5.092952968846636 0.7574981433518858 8.228598594665527 0"
                    }
                    joinStyle: ShapePath.MiterJoin
                    fillRule: ShapePath.WindingFill
                    fillColor: "transparent"
                }
                antialiasing: true
            }

            Shape {
                id: element12
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 10
                anchors.rightMargin: 59
                anchors.topMargin: 18
                anchors.bottomMargin: 47
                layer.samples: 16
                layer.enabled: true
                ShapePath {
                    id: vector_ShapePath_12
                    strokeWidth: 0.125
                    strokeColor: "transparent"
                    PathSvg {
                        id: vector_PathSvg_12
                        path: "M 5.749389184292962 0.9284759827188974 C 5.693342995464793 0.9857676468851271 5.61691633292291 1.0170182193076576 5.535394605098719 1.0430598853669226 C 5.025883794809067 1.2045182137702122 4.684511270088724 1.011810048301147 4.164810253311427 1.136810040729006 C 3.4820657505165356 1.3034766972994847 2.763655327615014 1.9857669731873284 2.595516753538203 2.683683630560548 C 2.4273781794613916 3.3816002879337677 2.5445656603615534 4.115975987535343 2.743274869085907 4.798267598318826 C 3.1254079768031455 6.095142553712331 3.8234379108063483 7.293058839312056 4.755842715502243 8.256600481564604 C 5.051358976966862 8.558683794658341 5.377446024925077 8.855558344967704 5.525204155657386 9.256599986370292 C 5.672962286389695 9.657641627772879 5.555774410689793 10.19930749328584 5.168546199728731 10.35034914983271 C 5.010597847324171 10.41284914604664 4.832269188236558 10.402435819190337 4.664130614159746 10.365977487095417 C 4.363519249451304 10.303477490881487 4.078193255212753 10.162852331568065 3.8081525403364584 10.011810675021195 C 2.9063184158419224 9.506602346098484 2.0809110222199934 8.8503512585639 1.3879763129374567 8.074309616594673 C 0.9192263589675982 7.553476303170395 0.5065223432799196 6.964932985103919 0.2517669381350938 6.308683015156382 C -0.3290753783064984 4.787849700221063 0.14986494918166526 3.0274337863003917 1.1281256830719646 1.7357671590740755 C 1.8414408053297926 0.7930588915784539 2.554756049064464 0.37118360378320026 3.7928673520818337 0.11597527523825056 C 4.185190666286718 0.03264194695301119 4.918886201519837 -0.07152480265528136 5.606725807558551 0.06910019755720889 C 5.917527409123848 0.13160019377113844 6.039810342513758 0.6420176541267277 5.749389184292962 0.9284759827188974 Z"
                    }
                    fillRule: ShapePath.WindingFill
                    fillColor: "#03a9f4"
                }
                antialiasing: true
            }

            Shape {
                id: element13
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 23
                anchors.rightMargin: 50
                anchors.topMargin: 21
                anchors.bottomMargin: 50
                layer.samples: 16
                layer.enabled: true
                ShapePath {
                    id: vector_ShapePath_13
                    strokeWidth: 0.125
                    strokeColor: "transparent"
                    PathSvg {
                        id: vector_PathSvg_13
                        path: "M 1.7708314071027398 4.145832757347976 C 1.7861167325461835 4.187499422086855 1.5568364570437851 4.052083555249922 1.5415511316003414 4.093750219988801 C 1.505885371283268 4.182291885469303 1.378507037634725 4.145833552852657 1.3020804056723165 4.093750219988801 C 0.9250423647808387 3.8281252313083156 0.6804783269004689 3.4166659342725603 0.46138865366976656 3.0104159588892494 C 0.23210877296714766 2.578124311253245 0.028303636292108976 2.1145827252109957 0.002828092937331396 1.6249994048278826 C -0.07359853902507721 0.21874941362328904 1.4243638671501564 0 1.4243638671501564 0 C 1.1696084373985323 0.5937499783498015 1.1747035458796802 1.3645818751547365 1.1696084373985323 1.7604151940546042 C 1.1594182204362364 2.5572901600960614 1.4855053245661523 3.4062494640536274 1.7708314071027398 4.145832757347976 Z"
                    }
                    fillRule: ShapePath.WindingFill
                    fillColor: "#37474f"
                }
                antialiasing: true
            }

            Shape {
                id: element14
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 10
                anchors.rightMargin: 6
                anchors.topMargin: 48
                anchors.bottomMargin: 18
                layer.samples: 16
                layer.enabled: true
                ShapePath {
                    id: vector_ShapePath_14
                    strokeWidth: 0.125
                    strokeColor: "transparent"
                    PathSvg {
                        id: vector_PathSvg_14
                        path: "M 0.035665602877054364 0 C 0.6623639381941735 0.18750000432490976 1.2890622735112927 0.3385424557516783 1.92595081578667 0.46875078691440697 C 2.5577442545829183 0.6041674463565911 3.1946326753814462 0.7239581585937644 3.8315212176568236 0.8177081607562193 C 5.1103934056867075 1.005208165081129 6.399456286582245 1.114582042255901 7.693613785049516 1.203123708377879 C 8.987771283516787 1.3124987031397217 10.287024006940035 1.4062488682836243 11.601561919323823 1.5572905280862177 C 12.905909624749352 1.7187488599697647 14.281587928544745 1.9218736939126142 15.591030737449403 2.5052070200051655 C 17.980636577221063 3.4999986527037246 20.375338613763493 4.479167411561718 22.82099071328242 5.286459039935368 C 25.25645260584309 6.119792371794466 27.72757937241972 6.848959510593477 30.22418250672994 7.390626148362213 C 32.71569041608418 7.963542817895854 35.24286295650067 8.33854216685886 37.77003671168567 8.447917161620703 C 39.033623589278164 8.505208827021862 40.29211718554427 8.48958303503728 41.54551385617851 8.369791368194482 C 42.81419583725013 8.239583037031753 44.07778392961112 8.078122951157388 45.33627570372449 7.859372961633702 C 47.843069044992966 7.411456294983335 50.30909937184513 6.677084677371446 52.58661269212225 5.531251338304165 C 53.73301206821793 4.973959653608891 54.838649158758386 4.312500534090119 55.837290412482474 3.5000005774370138 C 56.33661103934452 3.0989589273899165 56.81045827465578 2.656250123357726 57.24863759902985 2.17708345598654 C 57.691912026883045 1.7031251168948103 58.1046151657388 1.1927084798468919 58.41032167817867 0.6145834820337961 L 58.51222229003906 0.6614565739037774 C 57.95176036068904 1.8854148371628905 57.049927895221145 2.890626044564379 56.081857323110256 3.781251049585658 C 55.10359654404111 4.671876054606937 54.00814947824364 5.416665135923955 52.86684520562709 6.057290135178687 C 50.56895122847975 7.3333318054086964 48.06215788721127 8.171874893575174 45.51460371810976 8.723958187902822 C 42.96704954900825 9.265624825671559 40.358354138157196 9.609374204957831 37.74456350235016 9.520832538835853 C 35.135868091499106 9.447915873074283 32.54245738370118 9.067709158198467 29.989807989643698 8.505209145223738 C 24.89469965144068 7.354167477877001 19.967730335433167 5.520833439981842 15.234374708678859 3.312500262671251 C 14.067594918666664 2.7447919214170664 12.778531551863729 2.499997884579492 11.499659363833846 2.296872895416216 C 10.215692072324833 2.098956234532395 8.921534330903864 1.9635411583385616 7.627376832436593 1.8020828264550146 C 5.04925204246031 1.4791661626879207 2.450747081521208 1.0520828091553756 0 0.10937452133954183 L 0.035665602877054364 0 Z"
                    }
                    fillRule: ShapePath.WindingFill
                    fillColor: "#82aec0"
                }
                antialiasing: true
            }
            clip: true
        }
    }

    Minimizer_Minimized {
        id: minimizer_Minimized
        width: 70
        height: 70
        visible: false
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 24
        anchors.topMargin: 980
        state: "property_1_Default"
        clip: true
    }

    Workout_Minimized {
        id: workout_Minimized
        width: 70
        height: 70
        visible: false
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 24
        anchors.topMargin: 340
        state: "property_1_Default"
        clip: true
    }

    Nutrition_Minimized {
        id: nutrition_Minimized
        width: 70
        height: 70
        visible: false
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 24
        anchors.topMargin: 235
        state: "property_1_Default"
        clip: true
    }
    states: [
        State {
            name: "property_1_Variant2"

            PropertyChanges {
                target: title
                width: 96
                z: 3
            }

            PropertyChanges {
                target: workout_Minimized
                visible: true
                z: 1
            }

            PropertyChanges {
                target: workout
                visible: false
                z: 0
            }

            PropertyChanges {
                target: fitness_Freedom
                width: 6
                text: qsTr(" ")
                anchors.leftMargin: 87
                font.pixelSize: 40
            }

            PropertyChanges {
                target: minimize
                visible: false
                z: 0
            }

            PropertyChanges {
                target: nutrition_Minimized
                visible: true
                z: 2
            }

            PropertyChanges {
                target: minimizer_Minimized
                visible: true
                z: 0
            }

            PropertyChanges {
                target: nutrition
                visible: false
                z: 0
            }

            PropertyChanges {
                target: element15
                width: 117
            }
        },
        State {
            name: "property_1_Default"

            PropertyChanges {
                target: title
                width: 390
                z: 3
            }

            PropertyChanges {
                target: workout_Minimized
                visible: false
                z: 0
            }

            PropertyChanges {
                target: workout
                visible: true
                z: 2
            }

            PropertyChanges {
                target: fitness_Freedom
                width: 133
                text: qsTr("Fitness Freedom")
                anchors.leftMargin: 85
                font.pixelSize: 32
            }

            PropertyChanges {
                target: minimize
                visible: true
                z: 0
            }

            PropertyChanges {
                target: nutrition_Minimized
                visible: false
                z: 0
            }

            PropertyChanges {
                target: minimizer_Minimized
                visible: false
                z: 0
            }

            PropertyChanges {
                target: nutrition
                visible: true
                z: 1
            }

            PropertyChanges {
                target: element15
                width: 259
            }
        }
    ]
}

/*##^##
Designer {
    D{i:0;uuid:"90d5bac2-80e7-5de4-9e1f-747e0c0ce605"}D{i:1;uuid:"45b0c4b7-d904-5ec1-b14a-4016c168e11d"}
D{i:2;uuid:"fa408ff5-bf64-507c-90fc-2b4c195860e8"}D{i:3;uuid:"f744c53b-8ffb-535c-8f7b-2c3255b72bd0"}
D{i:4;uuid:"cc634d96-54fa-583d-ab95-761fa580ada0"}D{i:5;uuid:"35bfcc86-dbea-56dd-b56e-5db202d400e9"}
D{i:6;uuid:"327d637e-7a2c-5f00-8984-aa36359ff74c"}D{i:7;uuid:"d69be485-7e95-52ed-b116-243c75bc306a"}
D{i:8;uuid:"d69be485-7e95-52ed-b116-243c75bc306a_ShapePath_0"}D{i:9;uuid:"d69be485-7e95-52ed-b116-243c75bc306a-PathSvg_0"}
D{i:10;uuid:"0b1ff8b2-98ee-53cd-8b80-35b631a661b2"}D{i:11;uuid:"0b1ff8b2-98ee-53cd-8b80-35b631a661b2_ShapePath_0"}
D{i:12;uuid:"0b1ff8b2-98ee-53cd-8b80-35b631a661b2-PathSvg_0"}D{i:13;uuid:"cc0fdf6b-bb93-5259-a9b4-acd1ee65325e"}
D{i:14;uuid:"cc0fdf6b-bb93-5259-a9b4-acd1ee65325e_ShapePath_0"}D{i:15;uuid:"cc0fdf6b-bb93-5259-a9b4-acd1ee65325e-PathSvg_0"}
D{i:16;uuid:"d2fded24-a3df-5cf5-aee0-79b742940aa4"}D{i:17;uuid:"d2fded24-a3df-5cf5-aee0-79b742940aa4_ShapePath_0"}
D{i:18;uuid:"d2fded24-a3df-5cf5-aee0-79b742940aa4-PathSvg_0"}D{i:19;uuid:"6af0bc32-2ace-50ad-be22-5591444db235"}
D{i:20;uuid:"6af0bc32-2ace-50ad-be22-5591444db235_ShapePath_0"}D{i:21;uuid:"6af0bc32-2ace-50ad-be22-5591444db235-PathSvg_0"}
D{i:22;uuid:"86a0d747-7d19-5404-97b8-2ace404f616a"}D{i:23;uuid:"86a0d747-7d19-5404-97b8-2ace404f616a_ShapePath_0"}
D{i:24;uuid:"86a0d747-7d19-5404-97b8-2ace404f616a-PathSvg_0"}D{i:25;uuid:"ac0f8b40-89b9-5e92-ba6e-79f911ac6cf0"}
D{i:26;uuid:"ac0f8b40-89b9-5e92-ba6e-79f911ac6cf0_ShapePath_0"}D{i:27;uuid:"ac0f8b40-89b9-5e92-ba6e-79f911ac6cf0-PathSvg_0"}
D{i:28;uuid:"2e29ace4-b4b5-5fb0-b97f-63d6d85000e0"}D{i:29;uuid:"2e29ace4-b4b5-5fb0-b97f-63d6d85000e0_ShapePath_0"}
D{i:30;uuid:"2e29ace4-b4b5-5fb0-b97f-63d6d85000e0-PathSvg_0"}D{i:31;uuid:"ff114ad1-cac5-55d6-8aed-7acf1f5e4f5d"}
D{i:32;uuid:"ff114ad1-cac5-55d6-8aed-7acf1f5e4f5d_ShapePath_0"}D{i:33;uuid:"ff114ad1-cac5-55d6-8aed-7acf1f5e4f5d-PathSvg_0"}
D{i:34;uuid:"47d15c48-14a7-5649-9ad9-feddd1af3235"}D{i:35;uuid:"47d15c48-14a7-5649-9ad9-feddd1af3235_ShapePath_0"}
D{i:36;uuid:"47d15c48-14a7-5649-9ad9-feddd1af3235-PathSvg_0"}D{i:37;uuid:"f2b495bc-4d50-57a1-a333-925946d4855f"}
D{i:38;uuid:"f2b495bc-4d50-57a1-a333-925946d4855f_ShapePath_0"}D{i:39;uuid:"f2b495bc-4d50-57a1-a333-925946d4855f-PathSvg_0"}
D{i:40;uuid:"278110b3-a0ce-5769-ac42-4ad562fa26e2"}D{i:41;uuid:"278110b3-a0ce-5769-ac42-4ad562fa26e2_ShapePath_0"}
D{i:42;uuid:"278110b3-a0ce-5769-ac42-4ad562fa26e2-PathSvg_0"}D{i:43;uuid:"753e331c-7f9f-5677-ab1c-d4cc1296b4a6"}
D{i:44;uuid:"753e331c-7f9f-5677-ab1c-d4cc1296b4a6_ShapePath_0"}D{i:45;uuid:"753e331c-7f9f-5677-ab1c-d4cc1296b4a6-PathSvg_0"}
D{i:46;uuid:"1109b9a0-d013-5fb5-82dc-f52d383e7c55"}D{i:47;uuid:"1109b9a0-d013-5fb5-82dc-f52d383e7c55_ShapePath_0"}
D{i:48;uuid:"1109b9a0-d013-5fb5-82dc-f52d383e7c55-PathSvg_0"}D{i:49;uuid:"84fd997a-52c3-5a6f-87a4-5ff97cdb35ad"}
D{i:50;uuid:"84fd997a-52c3-5a6f-87a4-5ff97cdb35ad_ShapePath_0"}D{i:51;uuid:"84fd997a-52c3-5a6f-87a4-5ff97cdb35ad-PathSvg_0"}
D{i:52;uuid:"4739e638-db5a-5c19-b380-2aa24f60fe94"}D{i:53;uuid:"d3d24188-f9ac-5356-9278-0c499a2f1add"}
D{i:54;uuid:"490f1b8b-5f9b-5e46-a822-a39bd43de382"}
}
##^##*/

