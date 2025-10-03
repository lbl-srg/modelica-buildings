within Buildings.Fluid.Storage;
package dxsto "Ice tank model"
  extends Modelica.Icons.Package;

  model rtu
      BaseClasses.all_modes all_modes1(
      Qeva_cooling=Qeva_cooling,
      COP_cooling=COP_cooling,
      m_evarated=m_evarated,
      COP_charge=COP_charge,
      Qcharge=Qcharge,
      Qeva_discharge=Qeva_discharge,
      COP_discharge=COP_discharge,
      m_discharge=m_discharge)
        annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
      BaseClasses.tank tank1(
      Plant=Plant,
      UA=UA,
      eps=eps,
      Mhfs=Mhfs,
      Cp=Cp)
        annotation (Placement(transformation(extent={{40,0},{60,20}})));
    Controls.OBC.CDL.Conversions.RealToInteger reaToInt
      annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
    Modelica.Blocks.Sources.Constant const(k=0)
      annotation (Placement(transformation(extent={{0,40},{20,60}})));
    Modelica.Blocks.Interfaces.RealOutput Wele
      annotation (Placement(transformation(extent={{100,80},{120,100}})));
    Modelica.Blocks.Interfaces.RealOutput Qtes
      annotation (Placement(transformation(extent={{100,40},{120,60}})));
    Modelica.Blocks.Interfaces.RealOutput Qeva
      annotation (Placement(transformation(extent={{100,0},{120,20}})));
    Modelica.Blocks.Interfaces.RealOutput Qcon
      annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
    Modelica.Blocks.Interfaces.RealInput T_evawb
      annotation (Placement(transformation(extent={{-140,70},{-100,110}})));
    Modelica.Blocks.Interfaces.RealInput T_evadb
      annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
    Modelica.Blocks.Interfaces.RealInput m_eva
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.RealInput Qdem
      annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));
    Modelica.Blocks.Interfaces.RealInput T_condb
      annotation (Placement(transformation(extent={{-140,10},{-100,50}})));
    Modelica.Blocks.Interfaces.RealInput T_Amb
      annotation (Placement(transformation(extent={{-140,-110},{-100,-70}})));
    Modelica.Blocks.Interfaces.RealInput mode
      annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
    Modelica.Blocks.Interfaces.RealOutput Stes
      annotation (Placement(transformation(extent={{100,-80},{120,-60}})));
    parameter Boolean Plant=false annotation (Dialog(tab="Tank"));
    parameter Real UA=7.913 annotation (Dialog(tab="Tank"));
    parameter Real eps=1 annotation (Dialog(tab="Tank"));
    parameter Real Mhfs=0.161835*1000000000 annotation (Dialog(tab="Tank"));
    parameter Real Cp=3000 annotation (Dialog(tab="Tank"));
    parameter Real Qeva_cooling=5468.86
      annotation (Dialog(tab="modes", group="Q"));
    parameter Real Qcharge=4375.09 annotation (Dialog(tab="modes", group="Q"));
    parameter Real Qeva_discharge=7492.34
      annotation (Dialog(tab="modes", group="Q"));
    parameter Real COP_cooling=4.117132355
      annotation (Dialog(tab="modes", group="COP"));
    parameter Real COP_charge=3.09 annotation (Dialog(tab="modes", group="COP"));
    parameter Real COP_discharge=63.6
      annotation (Dialog(tab="modes", group="COP"));
    parameter Real m_evarated=0.291350
      annotation (Dialog(tab="modes", group="mass_flow"));
    parameter Real m_discharge=0.291350
      annotation (Dialog(tab="modes", group="mass_flow"));
  equation
    connect(all_modes1.Qtes,tank1. Qtes) annotation (Line(points={{1,-7},{30,-7},
            {30,0},{38,0}},      color={0,0,127}));
    connect(reaToInt.y,all_modes1. u) annotation (Line(points={{-18,50},{-10,50},
            {-10,2}},  color={255,127,0}));
    connect(const.y,tank1. T_TES) annotation (Line(points={{21,50},{30,50},{30,
            20},{38,20}}, color={0,0,127}));
    connect(const.y,tank1. T_win) annotation (Line(points={{21,50},{30,50},{30,
            10},{38,10}}, color={0,0,127}));
    connect(const.y,tank1. m_flow) annotation (Line(points={{21,50},{30,50},{30,
            5},{38,5}},   color={0,0,127}));
    connect(tank1.Stes,all_modes1. Stes) annotation (Line(points={{61,10},{70,
            10},{70,-30},{-32,-30},{-32,-20},{-22,-20}},
                                                     color={0,0,127}));
    connect(T_evawb, all_modes1.T_evawb) annotation (Line(points={{-120,90},{
            -60,90},{-60,0},{-22,0}}, color={0,0,127}));
    connect(T_evadb, all_modes1.T_evadb) annotation (Line(points={{-120,60},{
            -64,60},{-64,-4},{-22,-4}}, color={0,0,127}));
    connect(T_condb, all_modes1.T_condb) annotation (Line(points={{-120,30},{
            -68,30},{-68,-8},{-22,-8}}, color={0,0,127}));
    connect(m_eva, all_modes1.m_eva) annotation (Line(points={{-120,0},{-72,0},
            {-72,-12},{-22,-12}}, color={0,0,127}));
    connect(Qdem, all_modes1.Qdem) annotation (Line(points={{-120,-30},{-76,-30},
            {-76,-16},{-22,-16}}, color={0,0,127}));
    connect(T_Amb, tank1.T_Amb) annotation (Line(points={{-120,-90},{26,-90},{
            26,15},{38,15}}, color={0,0,127}));
    connect(mode, reaToInt.u) annotation (Line(points={{-120,-60},{-50,-60},{
            -50,50},{-42,50}}, color={0,0,127}));
    connect(tank1.Stes, Stes) annotation (Line(points={{61,10},{70,10},{70,-70},
            {110,-70}}, color={0,0,127}));
    connect(all_modes1.Qcon, Qcon) annotation (Line(points={{1,-19},{92,-19},{
            92,-30},{110,-30}}, color={0,0,127}));
    connect(all_modes1.Qeva, Qeva) annotation (Line(points={{1,-13},{92,-13},{
            92,10},{110,10}}, color={0,0,127}));
    connect(all_modes1.Qtes, Qtes) annotation (Line(points={{1,-7},{86,-7},{86,
            50},{110,50}}, color={0,0,127}));
    connect(all_modes1.Wele, Wele) annotation (Line(points={{1,-1},{20,-1},{20,
            28},{80,28},{80,90},{110,90}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      Documentation(revisions="<html>
<ul>
<li>
October 10, 2025 by Remi Patureau:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>These functions take the same form as documented in
<a href=\"https://energyplus.net/assets/nrel_custom/pdfs/pdfs_v24.2.0/EngineeringReference.pdf\">
EnergyPlus v24.2.0 Engineering Reference</a>
section 15.2.27.<\\p>
</html>"));
  end rtu;

package BaseClasses "Package with base classes"
  extends Modelica.Icons.BasesPackage;
  model tank
    parameter Boolean Plant=false;
    parameter Real UA = 7.913;
    parameter Real eps = 1;
    Real Qamb;
    Real Qpla;
    Real F(start=0);
    parameter Real Mhfs = 0.161835 * 1000000000;
    parameter  Real Cp = 3000;
    Real hope;

    Modelica.Blocks.Interfaces.RealInput T_TES
      annotation (Placement(transformation(extent={{-140,80},{-100,120}})));
    Modelica.Blocks.Interfaces.RealInput T_Amb
      annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
    Modelica.Blocks.Interfaces.RealInput T_win
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.RealInput m_flow
      annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
    Modelica.Blocks.Interfaces.RealInput Qtes
      annotation (Placement(transformation(extent={{-140,-120},{-100,-80}})));
    Modelica.Blocks.Interfaces.RealOutput Stes
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  equation
    Qamb + Qpla + Qtes + hope = Mhfs * der(F);
    if F < 0 then
      if Qamb + Qpla + Qtes <0 then
        hope = -(Qamb + Qpla + Qtes);
      else
        hope = 0;
      end if;
    else
      hope = 0;
    end if;
    Qamb = UA * (T_TES - T_Amb);
    Stes = F;
    if Plant == true then
      Qpla = m_flow * Cp * eps * (T_TES - T_win);
    else
      Qpla = 0;
    end if;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));

  end tank;

  model cooling_only_tescurve
    Real ConstantCubic[:] = {1, 0, 0, 0, -100, 100};
    Real Cool_Cap_fT[:] = {0.9712123, -0.015275502, 0.0014434524, -0.00039321, -0.0000068364, -0.0002905956, -100, 100, -100, 100};
    Real Cool_EIR_fT[:] = {0.28687133, 0.023902164,  -0.000810648, 0.013458546, 0.0003389364, -0.0004870044, -100, 100, -100, 100};
    Real Cool_PLF_fPLR[:] = {0.90949556, 0.09864773, -0.00819488, 0, 1, 0.7, 1};
    Real Cool_SHR_fT[:] = {1.3294540786, -0.0990649255, 0.0008310043, 0.0652277735, -0.0000793358, -0.0005874422, 24.44, 26.67, 29.44, 46.1, 0.6661, 1.6009};
    Real Cool_SHR_fFF[:] = {0.9317, -0.0077, 0.0760, 0.69, 1.30};

    Real PSZ_AC_Unitary_PackagecoolCapFT[:] = {0.766956, 0.0107756, -4.14703e-05, 0.00134961, -0.000261144, 0.000457488, 12.77778, 23.88889, 21.11111, 46.11111};
    Real PSZ_AC_Unitary_PackagecoolFFF[:] = {0.8, 0.2, 0, 0.5, 1.5};
    Real PSZ_AC_DX_Unitary_Package_EIRFT[:] = {0.297145, 0.0430933, -0.000748766, 0.00597727, 0.000482112, -0.000956448, 12.77778, 23.88889, 21.11111, 46.11111};
    Real PSZ_AC_Unitary_PackagecoolEIRFFF[:] = {1.156, -0.1816, 0.0256, 0.5, 1.5};
    Real PSZ_AC_Unitary_PackagecoolPLR[:] = {0.75, 0.25,  0, 0, 1};

    Real Qevarated = 10;
    Real COP = 3.23372055845678;
    Real m_evarated = 10;
    Real SHRrated = 0.7;
    Real PLR;
    Real frm_eva;
    Real SHR;
    Real EvapCapTempModFac;
    Real EvapCapFlowModFac;
    Real EIRTempModFac;
    Real EIRFlowModFac;
    Real EvapPartLoadFac;
    Real SHRTempModFac;
    Real SHRTFlowModFac;

    Modelica.Blocks.Interfaces.RealInput T_evawb
      annotation (Placement(transformation(extent={{-140,80},{-100,120}})));
    Modelica.Blocks.Interfaces.RealInput T_condb
      annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
    Modelica.Blocks.Interfaces.RealInput m_eva
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.RealInput Qdem
      annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
    Modelica.Blocks.Interfaces.RealOutput Wele
      annotation (Placement(transformation(extent={{100,40},{120,60}})));
    Modelica.Blocks.Interfaces.RealOutput Qeva
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Interfaces.RealOutput Qcon
      annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  equation

    frm_eva = m_eva / m_evarated;

    EvapCapTempModFac =
    Cool_Cap_fT[1] +
    Cool_Cap_fT[2] * T_evawb +
    Cool_Cap_fT[3] * T_evawb * T_evawb +
    Cool_Cap_fT[4] * T_condb +
    Cool_Cap_fT[5] * T_condb * T_condb +
    Cool_Cap_fT[6] * T_evawb * T_condb;

    EvapCapFlowModFac =
    ConstantCubic[1] +
    ConstantCubic[2] * frm_eva +
    ConstantCubic[3] * frm_eva * frm_eva;

    EIRTempModFac =
    Cool_EIR_fT[1] +
    Cool_EIR_fT[2] * T_evawb +
    Cool_EIR_fT[3] * T_evawb * T_evawb +
    Cool_EIR_fT[4] * T_condb +
    Cool_EIR_fT[5] * T_condb * T_condb +
    Cool_EIR_fT[6] * T_evawb * T_condb;

    EIRFlowModFac =
    ConstantCubic[1] +
    ConstantCubic[2] * frm_eva +
    ConstantCubic[3] * frm_eva * frm_eva;

    PLR = Qdem / Qeva;

    EvapPartLoadFac =
    Cool_PLF_fPLR[1] +
    Cool_PLF_fPLR[2] * PLR +
    Cool_PLF_fPLR[3] * PLR * PLR;

    Qeva = Qevarated * EvapCapTempModFac * EvapCapFlowModFac;

    Wele = Qeva * EIRTempModFac * EIRFlowModFac * PLR / (COP * EvapPartLoadFac);
    Wele + Qcon + Qeva = 0;

    SHRTempModFac =
    Cool_SHR_fT[1] +
    Cool_SHR_fT[2] * T_evawb +
    Cool_SHR_fT[3] * T_evawb * T_evawb +
    Cool_SHR_fT[4] * T_condb +
    Cool_SHR_fT[5] * T_condb * T_condb +
    Cool_SHR_fT[6] * T_evawb * T_condb;

    SHRTFlowModFac =
    Cool_SHR_fFF[1] +
    Cool_SHR_fFF[2] * frm_eva +
    Cool_SHR_fFF[3] * frm_eva * frm_eva;

    SHR = SHRrated * SHRTempModFac * SHRTFlowModFac;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end cooling_only_tescurve;

  model cooling_only
    parameter Real Qevarated = 5468.86;
    parameter Real COP = 4.117132355;
    parameter Real m_evarated = 0.291350;
    parameter Real SHRrated = 0.7;
    Real PLR;
    Real frm_eva;
    Real SHR;
    Real EvapCapTempModFac;
    Real EvapCapFlowModFac;
    Real EIRTempModFac;
    Real EIRFlowModFac;
    Real EvapPartLoadFac;
    Real SHRTempModFac;
    Real SHRTFlowModFac;

    Real ConstantCubic[:] = {1, 0, 0, 0, -100, 100};
    Real Cool_Cap_fT[:] = {0.9712123, -0.015275502, 0.0014434524, -0.00039321, -0.0000068364, -0.0002905956, -100, 100, -100, 100};
    Real Cool_EIR_fT[:] = {0.28687133, 0.023902164,  -0.000810648, 0.013458546, 0.0003389364, -0.0004870044, -100, 100, -100, 100};
    Real Cool_PLF_fPLR[:] = {0.90949556, 0.09864773, -0.00819488, 0, 1, 0.7, 1};
    Real Cool_SHR_fT[:] = {1.3294540786, -0.0990649255, 0.0008310043, 0.0652277735, -0.0000793358, -0.0005874422, 24.44, 26.67, 29.44, 46.1, 0.6661, 1.6009};
    Real Cool_SHR_fFF[:] = {0.9317, -0.0077, 0.0760, 0.69, 1.30};

    Real PSZ_AC_Unitary_PackagecoolCapFT[:] = {0.766956, 0.0107756, -4.14703e-05, 0.00134961, -0.000261144, 0.000457488, 12.77778, 23.88889, 21.11111, 46.11111};
    Real PSZ_AC_Unitary_PackagecoolFFF[:] = {0.8, 0.2, 0, 0.5, 1.5};
    Real PSZ_AC_DX_Unitary_Package_EIRFT[:] = {0.297145, 0.0430933, -0.000748766, 0.00597727, 0.000482112, -0.000956448, 12.77778, 23.88889, 21.11111, 46.11111};
    Real PSZ_AC_Unitary_PackagecoolEIRFFF[:] = {1.156, -0.1816, 0.0256, 0.5, 1.5};
    Real PSZ_AC_Unitary_PackagecoolPLR[:] = {0.75, 0.25,  0, 0, 1};

    Modelica.Blocks.Interfaces.RealInput T_evawb
      annotation (Placement(transformation(extent={{-140,80},{-100,120}})));
    Modelica.Blocks.Interfaces.RealInput T_condb
      annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
    Modelica.Blocks.Interfaces.RealInput m_eva
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.RealInput Qdem
      annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
    Modelica.Blocks.Interfaces.RealOutput Wele
      annotation (Placement(transformation(extent={{100,40},{120,60}})));
    Modelica.Blocks.Interfaces.RealOutput Qeva
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Interfaces.RealOutput Qcon
      annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  equation

    frm_eva = m_eva / m_evarated;

    EvapCapTempModFac =
    PSZ_AC_Unitary_PackagecoolCapFT[1] +
    PSZ_AC_Unitary_PackagecoolCapFT[2] * T_evawb +
    PSZ_AC_Unitary_PackagecoolCapFT[3] * T_evawb * T_evawb +
    PSZ_AC_Unitary_PackagecoolCapFT[4] * T_condb +
    PSZ_AC_Unitary_PackagecoolCapFT[5] * T_condb * T_condb +
    PSZ_AC_Unitary_PackagecoolCapFT[6] * T_evawb * T_condb;

    EvapCapFlowModFac =
    PSZ_AC_Unitary_PackagecoolFFF[1] +
    PSZ_AC_Unitary_PackagecoolFFF[2] * frm_eva +
    PSZ_AC_Unitary_PackagecoolFFF[3] * frm_eva * frm_eva;

    EIRTempModFac =
    PSZ_AC_DX_Unitary_Package_EIRFT[1] +
    PSZ_AC_DX_Unitary_Package_EIRFT[2] * T_evawb +
    PSZ_AC_DX_Unitary_Package_EIRFT[3] * T_evawb * T_evawb +
    PSZ_AC_DX_Unitary_Package_EIRFT[4] * T_condb +
    PSZ_AC_DX_Unitary_Package_EIRFT[5] * T_condb * T_condb +
    PSZ_AC_DX_Unitary_Package_EIRFT[6] * T_evawb * T_condb;

    EIRFlowModFac =
    PSZ_AC_Unitary_PackagecoolEIRFFF[1] +
    PSZ_AC_Unitary_PackagecoolEIRFFF[2] * frm_eva +
    PSZ_AC_Unitary_PackagecoolEIRFFF[3] * frm_eva * frm_eva;

    PLR = min(max(0,Qdem / Qeva),1);

    EvapPartLoadFac =
    PSZ_AC_Unitary_PackagecoolPLR[1] +
    PSZ_AC_Unitary_PackagecoolPLR[2] * PLR +
    PSZ_AC_Unitary_PackagecoolPLR[3] * PLR * PLR;

    Qeva = Qevarated * EvapCapTempModFac * EvapCapFlowModFac;

    Wele = Qeva * EIRTempModFac * EIRFlowModFac * PLR / (COP * EvapPartLoadFac);
    Wele + Qcon + Qeva = 0;

    SHRTempModFac =
    Cool_SHR_fT[1] +
    Cool_SHR_fT[2] * T_evawb +
    Cool_SHR_fT[3] * T_evawb * T_evawb +
    Cool_SHR_fT[4] * T_condb +
    Cool_SHR_fT[5] * T_condb * T_condb +
    Cool_SHR_fT[6] * T_evawb * T_condb;

    SHRTFlowModFac =
    Cool_SHR_fFF[1] +
    Cool_SHR_fFF[2] * frm_eva +
    Cool_SHR_fFF[3] * frm_eva * frm_eva;

    SHR = SHRrated * SHRTempModFac * SHRTFlowModFac;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end cooling_only;

  model charge_only_save
    Real Qchrated = 4375.09;
    Real COP = 3.09;
    Real TESCapTempModFac;
    Real EIRTempModFac;
    Boolean y;

    Modelica.Blocks.Interfaces.RealInput T_evawb
      annotation (Placement(transformation(extent={{-140,80},{-100,120}})));
    Modelica.Blocks.Interfaces.RealInput T_condb
      annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
    Modelica.Blocks.Interfaces.RealInput m_eva
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.RealInput Qdem
      annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
    Modelica.Blocks.Tables.CombiTable2Ds ChargeOnly_Cap_fT(tableOnFile=false,
        table=[0,0.0,0.0165,0.033,0.0495,0.066,0.0825,0.099,0.1155,0.132,0.1485,0.165,0.2485,0.332,0.4155,0.499,0.5825,0.666,0.7495,0.833,0.9165,1.0;
  -30.0,1.49824556678101,1.46806170364912,1.44052617800393,1.41563898984543,1.39340013917363,1.37380962598852,1.35686745029011,1.3425736120784,1.33092811135338,1.32193094811506,1.42668437190192,1.41338906040552,1.40035311136274,1.3875765247736,1.37505930063809,1.36280143895621,1.35080293972796,1.33906380295334,1.32758402863235,1.31636361676499,1.30540256735126;
  -22.0,1.50015546707142,1.4705835604194,1.44365999125407,1.41938475957544,1.3977578653835,1.37877930867826,1.36244908945972,1.34876720772787,1.33773366348272,1.32934845672426,1.40282715364577,1.39042093324161,1.37827407529108,1.36638657979418,1.35475844675091,1.34338967616127,1.33228026802526,1.32143022234288,1.31083953911413,1.30050821833902,1.29043626001753;
  -14.0,1.48443264447972,1.45547269430757,1.4291610816221,1.40549780642334,1.38448286871126,1.36611626848589,1.35039800574721,1.33732808049523,1.32690649272994,1.31913324245135,1.3664290373131,1.35491190800118,1.34365414114289,1.33265573673823,1.3219166947872,1.31143701528981,1.30121669824604,1.2912557436559,1.2815541515194,1.27211192183652,1.26292905460728;
  -6.0,1.45107709900591,1.42272910531362,1.39702944910802,1.37397813038912,1.35357514915692,1.33582050541141,1.32071419915259,1.30825623038047,1.29844659909505,1.29128530529632,1.31749002290391,1.30686198468423,1.29649330891818,1.28638399560576,1.27653404474698,1.26694345634182,1.25761223039029,1.2485403668924,1.23972786584814,1.2311747272575,1.2228809511205;
  2.0,1.40008883064999,1.37235279343756,1.34726509371183,1.32482573147279,1.30503470672045,1.28789201945481,1.27339766967586,1.26155165738361,1.25235398257805,1.24580464525919,1.25601011041819,1.24627116329075,1.23679157861694,1.22757135639677,1.21861049663022,1.20990899931731,1.20146686445803,1.19328409205237,1.18536068210035,1.17769663460196,1.1702919495572;
  10.0,1.33146783941196,1.30434375867939,1.27986801543353,1.25804060967436,1.23886154140188,1.2223308106161,1.20844841731702,1.19721436150463,1.18862864317894,1.18269126233994,1.18198929985595,1.17313944382075,1.16454895023919,1.15621781911125,1.14814605043695,1.14033364421628,1.13278060044923,1.12548691913582,1.11845260027604,1.11167764386989,1.10516204991738;
  18.0,1.24521412529181,1.21870200103912,1.19483821427311,1.17362276499381,1.1550556532012,1.13913687889529,1.12586644207607,1.11524434274355,1.10727058089772,1.10194515653859,1.09542759121718,1.08746682627423,1.0797654237849,1.07232338374921,1.06514070616715,1.05821739103872,1.05155343836392,1.04514884814275,1.03900362037521,1.0331177550613,1.02749125220103;
  26.0,1.14132768828956,1.11542752051673,1.09217569023059,1.07157219743115,1.05361704211841,1.03831022429236,1.025651743953,1.01564160110035,1.00827979573439,1.00356632785512,0.996324984501889,0.989253310651177,0.982440999254095,0.975888050310645,0.969594463820825,0.963560239784636,0.957785378202078,0.952269879073151,0.947013742397854,0.942016968176189,0.937279556408154;
  34.0,1.01980852840519,0.994520317112224,0.971880443305954,0.951888906986379,0.9345457081535,0.919850846807317,0.90780432294783,0.898406136575038,0.891656287688942,0.887554776289542,0.884681479710075,0.878498896951605,0.872575676646765,0.866911818795556,0.861507323397978,0.856362190454031,0.851476419963715,0.846850011927029,0.842482966343974,0.838375283214551,0.834526962538758;
  42.0,0.880656645638712,0.855980390825611,0.833952473499206,0.814572893659497,0.797841651306483,0.783758746440166,0.772324179060544,0.763537949167617,0.757400056761387,0.753910501841852,0.760497076841737,0.755203585175508,0.75016945596291,0.745394689203943,0.740879284898607,0.736623243046902,0.732626563648827,0.728889246704383,0.72541129221357,0.722192700176388,0.719233470592837;
  50.0,0.723872039990123,0.699807741656888,0.678391780810348,0.659624157450504,0.643504871577356,0.630033923190903,0.619211312291147,0.611037038878086,0.605511102951721,0.602633504512051,0.623771775896875,0.619367375322888,0.615222337202532,0.611336661535807,0.607710348322712,0.604343397563249,0.601235809257416,0.598387583405214,0.595798720006643,0.593469219061702,0.591399080570393])
      annotation (Placement(transformation(extent={{-20,60},{0,80}})));
    Modelica.Blocks.Tables.CombiTable2Ds ChargeOnly_EIR_fT(tableOnFile=false,
        table=[0,0.0,0.0165,0.033,0.0495,0.066,0.0825,0.099,0.1155,0.132,0.1485,0.165,0.2485,0.332,0.4155,0.499,0.5825,0.666,0.7495,0.833,0.9165,1.0;
  -30.0,1.510765188,1.51113820746276,1.51071413909006,1.50949298288187,1.50747473883822,1.50465940695909,1.5010469872445,1.49663747969442,1.49143088430888,1.48542720108786,1.3408428051994,1.33798668570241,1.33510998668922,1.33221270815981,1.32929485011418,1.32635641255235,1.3233973954743,1.32041779888005,1.31741762276958,1.31439686714289,1.311355532;
  -22.0,1.136458956,1.13867291544276,1.14008978705006,1.14070957082187,1.14053226675822,1.13955787485909,1.1377863951245,1.13521782755442,1.13185217214888,1.12768942890786,1.0231481569594,1.02151088228641,1.01985302809722,1.01817459439181,1.01647558117018,1.01475598843235,1.0130158161783,1.01125506440805,1.00947373312158,1.00767182231889,1.005849332;
  -14.0,0.860350612,0.864405511422764,0.867663323010055,0.870124046761874,0.87178768267822,0.872654230759094,0.872723691004495,0.871996063414424,0.87047134798888,0.868149544727864,0.7975331247194,0.797114694870414,0.796675685505216,0.796216096623806,0.795735928226184,0.79523518031235,0.794713852882304,0.794171945936046,0.793609459473576,0.793026393494894,0.792422748;
  -6.0,0.682440156,0.688335995402764,0.693434746970055,0.697736410701874,0.70124098659822,0.703948474659094,0.705858874884495,0.706972187274424,0.70728841182888,0.706807548547864,0.6639977084794,0.664798123454414,0.665577958913216,0.666337214855806,0.667075891282184,0.66779398819235,0.668491505586304,0.669168443464046,0.669824801825576,0.670460580670894,0.67107578;
  2.0,0.602727588,0.610464367382764,0.617404058930055,0.623546662641874,0.62889217851822,0.633440606559094,0.637191946764495,0.640146199134424,0.64230336366888,0.643663440367864,0.6225419082394,0.624561168038414,0.626559848321216,0.628537949087806,0.630495470338184,0.63243241207235,0.634348774290304,0.636244556992046,0.638119760177576,0.639974383846894,0.641808428;
  10.0,0.621212908,0.630790627362764,0.639571258890055,0.647554802581874,0.65474125843822,0.661130626459094,0.666722906644495,0.671518098994424,0.67551620350888,0.678717220187864,0.6731657239994,0.676403828622414,0.679621353729216,0.682818299319806,0.685994665394184,0.68915045195235,0.692285658994304,0.695400286520046,0.698494334529576,0.701567803022894,0.704620692;
  18.0,0.737896116,0.749314775342764,0.759936346850055,0.769760830521874,0.77878822635822,0.787018534359094,0.794451754524495,0.801087886854424,0.80692693134888,0.811968888007864,0.8158691557594,0.820326105206414,0.824762475137216,0.829178265551806,0.833573476450184,0.83794810783235,0.842302159698304,0.846635632048046,0.850948524881576,0.855240838198894,0.859512572;
  26.0,0.952777212,0.966036811322764,0.978499322810055,0.990164746461874,1.00103308227822,1.01110433025909,1.0203784904045,1.02885556271442,1.03653554718888,1.04341844382786,1.0506522035194,1.05632799779041,1.06198321254522,1.06761784778381,1.07323190350618,1.07882537971235,1.0843982764023,1.08995059357605,1.09548233123358,1.10099348937489,1.106484068;
  34.0,1.265856196,1.28095673530276,1.29526018677006,1.30876655040187,1.32147582619822,1.33338801415909,1.3445031142845,1.35482112657442,1.36434205102888,1.37306588764786,1.3775148672794,1.38440950637441,1.39128356595322,1.39813704601581,1.40496994656218,1.41178226759235,1.4185740091063,1.42534517110405,1.43209575358558,1.43882575655089,1.44553518;
  42.0,1.677133068,1.69407454728276,1.71021893873006,1.72556624234187,1.74011645811822,1.75386958605909,1.7668256261645,1.77898457843442,1.79034644286888,1.80091121946786,1.7964571470394,1.80457063095841,1.81266353536122,1.82073586024781,1.82878760561818,1.83681877147235,1.8448293578103,1.85281936463205,1.86078879193758,1.86873763972689,1.876665908;
  50.0,2.186607828,2.20539024726276,2.22337557869005,2.24056382228187,2.25695497803822,2.27254904595909,2.28734602604449,2.30134591829442,2.31454872270888,2.32695443928786,2.3074790427994,2.31681137154241,2.32612312076922,2.33541429047981,2.34468488067418,2.35393489135235,2.3631643225143,2.37237317416005,2.38156144628958,2.39072913890289,2.399876252])
      annotation (Placement(transformation(extent={{-20,20},{0,40}})));
    Modelica.Blocks.Interfaces.RealInput Stes
      annotation (Placement(transformation(extent={{-140,-120},{-100,-80}})));
    Modelica.Blocks.Interfaces.RealOutput Wele
      annotation (Placement(transformation(extent={{100,40},{120,60}})));
    Modelica.Blocks.Interfaces.RealOutput Qtes
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Interfaces.RealOutput Qcon
      annotation (Placement(transformation(extent={{100,-60},{120,-40}})));

  equation
    y=not
         (Stes > 1);

    TESCapTempModFac = ChargeOnly_Cap_fT.y;
    EIRTempModFac = ChargeOnly_EIR_fT.y;

    if y == true then
      Qtes = Qchrated * TESCapTempModFac;
    else
      Qtes = 0;
    end if;

    Wele = Qtes * EIRTempModFac / COP;
    Wele + Qcon + Qtes = 0;

    connect(Stes, ChargeOnly_Cap_fT.u2) annotation (Line(points={{-120,-100},{-60,
            -100},{-60,64},{-22,64}}, color={0,0,127}));
    connect(Stes, ChargeOnly_EIR_fT.u2) annotation (Line(points={{-120,-100},{-60,
            -100},{-60,24},{-22,24}}, color={0,0,127}));
    connect(T_condb, ChargeOnly_Cap_fT.u1) annotation (Line(points={{-120,50},{-80,
            50},{-80,76},{-22,76}}, color={0,0,127}));
    connect(T_condb, ChargeOnly_EIR_fT.u1) annotation (Line(points={{-120,50},{-80,
            50},{-80,36},{-22,36}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end charge_only_save;

  model charge_only
    parameter Real Qchrated = 4375.09;
    parameter Real COP = 3.09;
    Real TESCapTempModFac;
    Real EIRTempModFac;
    Real Qtes_t;

    Modelica.Blocks.Interfaces.RealInput T_evawb
      annotation (Placement(transformation(extent={{-140,80},{-100,120}})));
    Modelica.Blocks.Interfaces.RealInput T_condb
      annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
    Modelica.Blocks.Interfaces.RealInput m_eva
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.RealInput Qdem
      annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
    Modelica.Blocks.Tables.CombiTable2Ds ChargeOnly_Cap_fT(tableOnFile=false,
        table=[0,0.0,0.0165,0.033,0.0495,0.066,0.0825,0.099,0.1155,0.132,0.1485,0.165,0.2485,0.332,0.4155,0.499,0.5825,0.666,0.7495,0.833,0.9165,1.0;
  -30.0,1.49824556678101,1.46806170364912,1.44052617800393,1.41563898984543,1.39340013917363,1.37380962598852,1.35686745029011,1.3425736120784,1.33092811135338,1.32193094811506,1.42668437190192,1.41338906040552,1.40035311136274,1.3875765247736,1.37505930063809,1.36280143895621,1.35080293972796,1.33906380295334,1.32758402863235,1.31636361676499,1.30540256735126;
  -22.0,1.50015546707142,1.4705835604194,1.44365999125407,1.41938475957544,1.3977578653835,1.37877930867826,1.36244908945972,1.34876720772787,1.33773366348272,1.32934845672426,1.40282715364577,1.39042093324161,1.37827407529108,1.36638657979418,1.35475844675091,1.34338967616127,1.33228026802526,1.32143022234288,1.31083953911413,1.30050821833902,1.29043626001753;
  -14.0,1.48443264447972,1.45547269430757,1.4291610816221,1.40549780642334,1.38448286871126,1.36611626848589,1.35039800574721,1.33732808049523,1.32690649272994,1.31913324245135,1.3664290373131,1.35491190800118,1.34365414114289,1.33265573673823,1.3219166947872,1.31143701528981,1.30121669824604,1.2912557436559,1.2815541515194,1.27211192183652,1.26292905460728;
  -6.0,1.45107709900591,1.42272910531362,1.39702944910802,1.37397813038912,1.35357514915692,1.33582050541141,1.32071419915259,1.30825623038047,1.29844659909505,1.29128530529632,1.31749002290391,1.30686198468423,1.29649330891818,1.28638399560576,1.27653404474698,1.26694345634182,1.25761223039029,1.2485403668924,1.23972786584814,1.2311747272575,1.2228809511205;
  2.0,1.40008883064999,1.37235279343756,1.34726509371183,1.32482573147279,1.30503470672045,1.28789201945481,1.27339766967586,1.26155165738361,1.25235398257805,1.24580464525919,1.25601011041819,1.24627116329075,1.23679157861694,1.22757135639677,1.21861049663022,1.20990899931731,1.20146686445803,1.19328409205237,1.18536068210035,1.17769663460196,1.1702919495572;
  10.0,1.33146783941196,1.30434375867939,1.27986801543353,1.25804060967436,1.23886154140188,1.2223308106161,1.20844841731702,1.19721436150463,1.18862864317894,1.18269126233994,1.18198929985595,1.17313944382075,1.16454895023919,1.15621781911125,1.14814605043695,1.14033364421628,1.13278060044923,1.12548691913582,1.11845260027604,1.11167764386989,1.10516204991738;
  18.0,1.24521412529181,1.21870200103912,1.19483821427311,1.17362276499381,1.1550556532012,1.13913687889529,1.12586644207607,1.11524434274355,1.10727058089772,1.10194515653859,1.09542759121718,1.08746682627423,1.0797654237849,1.07232338374921,1.06514070616715,1.05821739103872,1.05155343836392,1.04514884814275,1.03900362037521,1.0331177550613,1.02749125220103;
  26.0,1.14132768828956,1.11542752051673,1.09217569023059,1.07157219743115,1.05361704211841,1.03831022429236,1.025651743953,1.01564160110035,1.00827979573439,1.00356632785512,0.996324984501889,0.989253310651177,0.982440999254095,0.975888050310645,0.969594463820825,0.963560239784636,0.957785378202078,0.952269879073151,0.947013742397854,0.942016968176189,0.937279556408154;
  34.0,1.01980852840519,0.994520317112224,0.971880443305954,0.951888906986379,0.9345457081535,0.919850846807317,0.90780432294783,0.898406136575038,0.891656287688942,0.887554776289542,0.884681479710075,0.878498896951605,0.872575676646765,0.866911818795556,0.861507323397978,0.856362190454031,0.851476419963715,0.846850011927029,0.842482966343974,0.838375283214551,0.834526962538758;
  42.0,0.880656645638712,0.855980390825611,0.833952473499206,0.814572893659497,0.797841651306483,0.783758746440166,0.772324179060544,0.763537949167617,0.757400056761387,0.753910501841852,0.760497076841737,0.755203585175508,0.75016945596291,0.745394689203943,0.740879284898607,0.736623243046902,0.732626563648827,0.728889246704383,0.72541129221357,0.722192700176388,0.719233470592837;
  50.0,0.723872039990123,0.699807741656888,0.678391780810348,0.659624157450504,0.643504871577356,0.630033923190903,0.619211312291147,0.611037038878086,0.605511102951721,0.602633504512051,0.623771775896875,0.619367375322888,0.615222337202532,0.611336661535807,0.607710348322712,0.604343397563249,0.601235809257416,0.598387583405214,0.595798720006643,0.593469219061702,0.591399080570393])
      annotation (Placement(transformation(extent={{-20,60},{0,80}})));
    Modelica.Blocks.Tables.CombiTable2Ds ChargeOnly_EIR_fT(tableOnFile=false,
        table=[0,0.0,0.0165,0.033,0.0495,0.066,0.0825,0.099,0.1155,0.132,0.1485,0.165,0.2485,0.332,0.4155,0.499,0.5825,0.666,0.7495,0.833,0.9165,1.0;
  -30.0,1.510765188,1.51113820746276,1.51071413909006,1.50949298288187,1.50747473883822,1.50465940695909,1.5010469872445,1.49663747969442,1.49143088430888,1.48542720108786,1.3408428051994,1.33798668570241,1.33510998668922,1.33221270815981,1.32929485011418,1.32635641255235,1.3233973954743,1.32041779888005,1.31741762276958,1.31439686714289,1.311355532;
  -22.0,1.136458956,1.13867291544276,1.14008978705006,1.14070957082187,1.14053226675822,1.13955787485909,1.1377863951245,1.13521782755442,1.13185217214888,1.12768942890786,1.0231481569594,1.02151088228641,1.01985302809722,1.01817459439181,1.01647558117018,1.01475598843235,1.0130158161783,1.01125506440805,1.00947373312158,1.00767182231889,1.005849332;
  -14.0,0.860350612,0.864405511422764,0.867663323010055,0.870124046761874,0.87178768267822,0.872654230759094,0.872723691004495,0.871996063414424,0.87047134798888,0.868149544727864,0.7975331247194,0.797114694870414,0.796675685505216,0.796216096623806,0.795735928226184,0.79523518031235,0.794713852882304,0.794171945936046,0.793609459473576,0.793026393494894,0.792422748;
  -6.0,0.682440156,0.688335995402764,0.693434746970055,0.697736410701874,0.70124098659822,0.703948474659094,0.705858874884495,0.706972187274424,0.70728841182888,0.706807548547864,0.6639977084794,0.664798123454414,0.665577958913216,0.666337214855806,0.667075891282184,0.66779398819235,0.668491505586304,0.669168443464046,0.669824801825576,0.670460580670894,0.67107578;
  2.0,0.602727588,0.610464367382764,0.617404058930055,0.623546662641874,0.62889217851822,0.633440606559094,0.637191946764495,0.640146199134424,0.64230336366888,0.643663440367864,0.6225419082394,0.624561168038414,0.626559848321216,0.628537949087806,0.630495470338184,0.63243241207235,0.634348774290304,0.636244556992046,0.638119760177576,0.639974383846894,0.641808428;
  10.0,0.621212908,0.630790627362764,0.639571258890055,0.647554802581874,0.65474125843822,0.661130626459094,0.666722906644495,0.671518098994424,0.67551620350888,0.678717220187864,0.6731657239994,0.676403828622414,0.679621353729216,0.682818299319806,0.685994665394184,0.68915045195235,0.692285658994304,0.695400286520046,0.698494334529576,0.701567803022894,0.704620692;
  18.0,0.737896116,0.749314775342764,0.759936346850055,0.769760830521874,0.77878822635822,0.787018534359094,0.794451754524495,0.801087886854424,0.80692693134888,0.811968888007864,0.8158691557594,0.820326105206414,0.824762475137216,0.829178265551806,0.833573476450184,0.83794810783235,0.842302159698304,0.846635632048046,0.850948524881576,0.855240838198894,0.859512572;
  26.0,0.952777212,0.966036811322764,0.978499322810055,0.990164746461874,1.00103308227822,1.01110433025909,1.0203784904045,1.02885556271442,1.03653554718888,1.04341844382786,1.0506522035194,1.05632799779041,1.06198321254522,1.06761784778381,1.07323190350618,1.07882537971235,1.0843982764023,1.08995059357605,1.09548233123358,1.10099348937489,1.106484068;
  34.0,1.265856196,1.28095673530276,1.29526018677006,1.30876655040187,1.32147582619822,1.33338801415909,1.3445031142845,1.35482112657442,1.36434205102888,1.37306588764786,1.3775148672794,1.38440950637441,1.39128356595322,1.39813704601581,1.40496994656218,1.41178226759235,1.4185740091063,1.42534517110405,1.43209575358558,1.43882575655089,1.44553518;
  42.0,1.677133068,1.69407454728276,1.71021893873006,1.72556624234187,1.74011645811822,1.75386958605909,1.7668256261645,1.77898457843442,1.79034644286888,1.80091121946786,1.7964571470394,1.80457063095841,1.81266353536122,1.82073586024781,1.82878760561818,1.83681877147235,1.8448293578103,1.85281936463205,1.86078879193758,1.86873763972689,1.876665908;
  50.0,2.186607828,2.20539024726276,2.22337557869005,2.24056382228187,2.25695497803822,2.27254904595909,2.28734602604449,2.30134591829442,2.31454872270888,2.32695443928786,2.3074790427994,2.31681137154241,2.32612312076922,2.33541429047981,2.34468488067418,2.35393489135235,2.3631643225143,2.37237317416005,2.38156144628958,2.39072913890289,2.399876252])
      annotation (Placement(transformation(extent={{-20,20},{0,40}})));
    Modelica.Blocks.Interfaces.RealInput Stes
      annotation (Placement(transformation(extent={{-140,-120},{-100,-80}})));
    Modelica.Blocks.Interfaces.RealOutput Wele
      annotation (Placement(transformation(extent={{100,40},{120,60}})));
    Modelica.Blocks.Interfaces.RealOutput Qtes
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Interfaces.RealOutput Qcon
      annotation (Placement(transformation(extent={{100,-60},{120,-40}})));

    Modelica.Blocks.Sources.RealExpression realExpression(y=Qtes_t)
      annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
    Controls.OBC.CDL.Reals.Hysteresis hys(uLow=0.999,uHigh=1)
      annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
    Modelica.Blocks.Logical.Switch switch1
      annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
    Modelica.Blocks.Sources.RealExpression realExpression1
      annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  equation

    TESCapTempModFac = ChargeOnly_Cap_fT.y;
    EIRTempModFac = ChargeOnly_EIR_fT.y;

    Qtes_t = Qchrated * TESCapTempModFac;

    Wele = Qtes * EIRTempModFac / COP;
    Wele + Qcon + Qtes = 0;

    connect(Stes, ChargeOnly_Cap_fT.u2) annotation (Line(points={{-120,-100},{-60,
            -100},{-60,64},{-22,64}}, color={0,0,127}));
    connect(Stes, ChargeOnly_EIR_fT.u2) annotation (Line(points={{-120,-100},{-60,
            -100},{-60,24},{-22,24}}, color={0,0,127}));
    connect(T_condb, ChargeOnly_Cap_fT.u1) annotation (Line(points={{-120,50},{-80,
            50},{-80,76},{-22,76}}, color={0,0,127}));
    connect(T_condb, ChargeOnly_EIR_fT.u1) annotation (Line(points={{-120,50},{-80,
            50},{-80,36},{-22,36}}, color={0,0,127}));
    connect(hys.y, switch1.u2)
      annotation (Line(points={{22,-30},{38,-30}}, color={255,0,255}));
    connect(realExpression.y, switch1.u3) annotation (Line(points={{21,-50},{30,-50},
            {30,-38},{38,-38}},                         color={0,0,127}));
    connect(realExpression1.y, switch1.u1) annotation (Line(points={{21,0},{30,0},
            {30,-22},{38,-22}}, color={0,0,127}));
    connect(switch1.y, Qtes) annotation (Line(points={{61,-30},{80,-30},{80,0},{110,
            0}}, color={0,0,127}));
    connect(Stes, hys.u) annotation (Line(points={{-120,-100},{-60,-100},{-60,-30},
            {-2,-30}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end charge_only;

  model discharge_only
    parameter Real Qevarated = 7492.34;
    parameter Real COP = 63.6;
    parameter Real m_evarated = 0.291350;
    parameter Real SHRrated = 0.64;
    Real evaPLR;
    Real frm_eva;
    Real SHR;
    Real EvapCapTempModFac;
    Real EvapCapFlowModFac;
    Real EIRTempModFac;
    Real EIRFlowModFac;
    Real EvapPartLoadFac;
    Real SHRTempModFac;
    Real SHRTFlowModFac;
    Real Qeva_th;

    Real ConstantCubic[:] = {1, 0, 0, 0, -100, 100};
    Real ConstantBi[:] = {1.0, 0.0, 0.0, 0.0, 0.0, 0.0, -100, 100, -100, 100};
    Real Discharge_Cap_fT[:] = {-0.561476105575098, 0.133948946696947, -0.0027652398813276, 0.0, 0.0, 0.0, -100, 100, -100, 100};
    Real Discharge_Cap_fFF[:] = {0.743258739392434, 0.167765026703717, 0.0852727911986869, 0, -100, 100};
    Real Discharge_SHR_fT_NREL[:] = {-3.129846005, 0.108185126, 0, 0.235966025, 0, -0.008227635,16.1, 23.9, 23.9, 29.4, 0.2, 2};
    Real Discharge_SHR_fFF[:] = {0.60557628, 0.506516665, -0.12647141, 0.2, 1.00};

    Modelica.Blocks.Interfaces.RealInput T_evawb
      annotation (Placement(transformation(extent={{-140,80},{-100,120}})));
    Modelica.Blocks.Interfaces.RealInput T_evadb
      annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
    Modelica.Blocks.Interfaces.RealInput m_eva
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.RealInput Qdem
      annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
    Modelica.Blocks.Interfaces.RealInput Stes
      annotation (Placement(transformation(extent={{-140,-120},{-100,-80}})));
    Modelica.Blocks.Interfaces.RealOutput Wele
      annotation (Placement(transformation(extent={{100,40},{120,60}})));
    Modelica.Blocks.Interfaces.RealOutput Qtes
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Interfaces.RealOutput Qeva
      annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  equation

    frm_eva = m_eva / m_evarated;

    EvapCapTempModFac =
    Discharge_Cap_fT[1] +
    Discharge_Cap_fT[2] * T_evawb +
    Discharge_Cap_fT[3] * T_evawb * T_evawb +
    Discharge_Cap_fT[4] * Stes +
    Discharge_Cap_fT[5] * Stes * Stes +
    Discharge_Cap_fT[6] * T_evawb * Stes;

    EvapCapFlowModFac =
    Discharge_Cap_fFF[1] +
    Discharge_Cap_fFF[2] * frm_eva +
    Discharge_Cap_fFF[3] * frm_eva * frm_eva;

    EIRTempModFac =
    ConstantBi[1] +
    ConstantBi[2] * T_evawb +
    ConstantBi[3] * T_evawb * T_evawb +
    ConstantBi[4] * Stes +
    ConstantBi[5] * Stes * Stes +
    ConstantBi[6] * T_evawb * Stes;

    EIRFlowModFac =
    ConstantCubic[1] +
    ConstantCubic[2] * frm_eva +
    ConstantCubic[3] * frm_eva * frm_eva;

    evaPLR = min(1,max(0,Qdem / max(Qeva,0.001)));

    EvapPartLoadFac =
    ConstantCubic[1] +
    ConstantCubic[2] * evaPLR +
    ConstantCubic[3] * evaPLR * evaPLR;

    Qeva_th = Qevarated * EvapCapTempModFac * EvapCapFlowModFac;

    if Stes <0 then
      Qeva = 0;
    else
      Qeva = min(Qdem, Qeva_th);
    end if;

    Wele = Qeva * EIRTempModFac * EIRFlowModFac * evaPLR / (COP * EvapPartLoadFac);
    Qtes + Qeva + Wele = 0;

    SHRTempModFac = min(max(
    Discharge_SHR_fT_NREL[1] +
    Discharge_SHR_fT_NREL[2] * T_evawb +
    Discharge_SHR_fT_NREL[3] * T_evawb * T_evawb +
    Discharge_SHR_fT_NREL[4] * T_evadb  +
    Discharge_SHR_fT_NREL[5] * T_evadb  * T_evadb  +
    Discharge_SHR_fT_NREL[6] * T_evawb * T_evadb, 0.2),2);

    SHRTFlowModFac =
    Discharge_SHR_fFF[1] +
    Discharge_SHR_fFF[2] * frm_eva +
    Discharge_SHR_fFF[3] * frm_eva * frm_eva;

    SHR = SHRrated * SHRTempModFac * SHRTFlowModFac;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end discharge_only;

  model all_modes
    Real E_ele;
    BaseClasses.cooling_only cooling_only1(
      Qevarated=Qeva_cooling,
      COP=COP_cooling,
      m_evarated=m_evarated)
      annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
    BaseClasses.discharge_only discharge_only1(
      Qevarated=Qeva_discharge,
      COP=COP_discharge,
      m_evarated=m_discharge)
      annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
    BaseClasses.charge_only charge_only1(Qchrated=Qcharge, COP=COP_charge)
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
    Modelica.Blocks.Interfaces.RealInput T_evawb
      annotation (Placement(transformation(extent={{-140,80},{-100,120}})));
    Modelica.Blocks.Interfaces.RealInput T_evadb
      annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
    Modelica.Blocks.Interfaces.RealInput m_eva
      annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
    Modelica.Blocks.Interfaces.RealInput Qdem
      annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
    Modelica.Blocks.Interfaces.RealInput Stes
      annotation (Placement(transformation(extent={{-140,-120},{-100,-80}})));
    Modelica.Blocks.Interfaces.RealInput T_condb
      annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
    Modelica.Blocks.Interfaces.IntegerInput u annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=270,
          origin={0,120})));
    Modelica.Blocks.Interfaces.RealOutput Wele
      annotation (Placement(transformation(extent={{100,80},{120,100}})));
    Modelica.Blocks.Interfaces.RealOutput Qtes
      annotation (Placement(transformation(extent={{100,20},{120,40}})));
    Modelica.Blocks.Interfaces.RealOutput Qeva
      annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
    Modelica.Blocks.Interfaces.RealOutput Qcon
      annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
    parameter Real Qeva_cooling=5468.86 annotation (Dialog(group="Q"));
    parameter Real COP_cooling=4.117132355 annotation (Dialog(group="COP"));
    parameter Real m_evarated=0.291350 annotation (Dialog(group="mass_flow"));
    parameter Real COP_charge=3.09 annotation (Dialog(group="COP"));
    parameter Real Qcharge=4375.09 annotation (Dialog(group="Q"));
    parameter Real Qeva_discharge=7492.34 annotation (Dialog(group="Q"));
    parameter Real COP_discharge=63.6 annotation (Dialog(group="COP"));
    parameter Real m_discharge=0.291350 annotation (Dialog(group="mass_flow"));
  equation
    if u == 1 then
      Qcon = cooling_only1.Qcon;
      Qeva = cooling_only1.Qeva;
      Qtes = 0;
      Wele = cooling_only1.Wele;
    elseif u == 4 then
      Qcon = charge_only1.Qcon;
      Qeva = 0;
      Qtes = charge_only1.Qtes;
      Wele = charge_only1.Wele;
    elseif u == 5 then
      Qcon = 0;
      Qeva = discharge_only1.Qeva;
      Qtes = discharge_only1.Qtes;
      Wele = discharge_only1.Wele;
    else
      Qcon = 0;
      Qeva = 0;
      Qtes = 0;
      Wele = 0;
    end if;
      der(E_ele) = Wele / 3600;
    connect(T_evawb, cooling_only1.T_evawb) annotation (Line(points={{-120,100},{-74,
            100},{-74,80},{-62,80}}, color={0,0,127}));
    connect(T_evawb, charge_only1.T_evawb) annotation (Line(points={{-120,100},{-74,
            100},{-74,10},{-62,10}}, color={0,0,127}));
    connect(T_evawb, discharge_only1.T_evawb) annotation (Line(points={{-120,100},
            {-74,100},{-74,-60},{-62,-60}}, color={0,0,127}));
    connect(T_condb, cooling_only1.T_condb) annotation (Line(points={{-120,20},{-90,
            20},{-90,75},{-62,75}}, color={0,0,127}));
    connect(T_condb, charge_only1.T_condb) annotation (Line(points={{-120,20},{-90,
            20},{-90,5},{-62,5}}, color={0,0,127}));
    connect(T_evadb, discharge_only1.T_evadb) annotation (Line(points={{-120,60},{
            -86,60},{-86,-65},{-62,-65}}, color={0,0,127}));
    connect(m_eva, cooling_only1.m_eva) annotation (Line(points={{-120,-20},{-80,-20},
            {-80,70},{-62,70}}, color={0,0,127}));
    connect(m_eva, charge_only1.m_eva) annotation (Line(points={{-120,-20},{-80,-20},
            {-80,0},{-62,0}}, color={0,0,127}));
    connect(m_eva, discharge_only1.m_eva) annotation (Line(points={{-120,-20},{-80,
            -20},{-80,-70},{-62,-70}}, color={0,0,127}));
    connect(Qdem, cooling_only1.Qdem) annotation (Line(points={{-120,-60},{-96,-60},
            {-96,65},{-62,65}}, color={0,0,127}));
    connect(Qdem, charge_only1.Qdem) annotation (Line(points={{-120,-60},{-96,-60},
            {-96,-5},{-62,-5}}, color={0,0,127}));
    connect(Qdem, discharge_only1.Qdem) annotation (Line(points={{-120,-60},{-96,-60},
            {-96,-75},{-62,-75}}, color={0,0,127}));
    connect(Stes, charge_only1.Stes) annotation (Line(points={{-120,-100},{-68,-100},
            {-68,-10},{-62,-10}}, color={0,0,127}));
    connect(Stes, discharge_only1.Stes) annotation (Line(points={{-120,-100},{-68,
            -100},{-68,-80},{-62,-80}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end all_modes;
end BaseClasses;

package Validation "Package that validates the ice tank model"
  extends Modelica.Icons.ExamplesPackage;
  model test_cooling
    extends Modelica.Icons.Example;
      BaseClasses.cooling_only cooling_only1
        annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    Modelica.Blocks.Sources.CombiTimeTable data(
        tableOnFile=true,
        fileName="D:/dxcoil/cooling_only.txt",
        verboseRead=false,
      columns=2:16,
        tableName="tab1",
        smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
      "Reader for \"CoolingTower_VariableSpeed_Merkel.idf\" energy plus example results"
      annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
      Modelica.Blocks.Math.Gain gain(k=1/3600)
        annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  equation
      connect(data.y[5], cooling_only1.T_evawb) annotation (Line(points={{-59,
              30},{-40,30},{-40,20},{-22,20}}, color={0,0,127}));
      connect(data.y[6], cooling_only1.T_condb) annotation (Line(points={{-59,
              30},{-40,30},{-40,15},{-22,15}}, color={0,0,127}));
      connect(data.y[2], cooling_only1.m_eva) annotation (Line(points={{-59,30},
              {-40,30},{-40,10},{-22,10}}, color={0,0,127}));
      connect(data.y[8], cooling_only1.Qdem) annotation (Line(points={{-59,30},
              {-40,30},{-40,5},{-22,5}}, color={0,0,127}));
      connect(data.y[12], gain.u) annotation (Line(points={{-59,30},{-40,30},{
              -40,-30},{-22,-30}}, color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)),
        experiment(
          StopTime=31536000,
          Interval=600,
          __Dymola_Algorithm="Dassl"));
  end test_cooling;

  model test_charge
    extends Modelica.Icons.Example;
      BaseClasses.charge_only charge_only1
        annotation (Placement(transformation(extent={{40,-20},{60,0}})));
      BaseClasses.tank tank1
        annotation (Placement(transformation(extent={{40,20},{60,40}})));
    Modelica.Blocks.Sources.CombiTimeTable data(
      tableOnFile=true,
      fileName="D:/dxcoil/cooling_only.txt",
      verboseRead=false,
        columns=2:16,
      tableName="tab1",
      smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
      "Reader for \"CoolingTower_VariableSpeed_Merkel.idf\" energy plus example results"
      annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
    Modelica.Blocks.Sources.Constant const
      annotation (Placement(transformation(extent={{-20,80},{0,100}})));
      Modelica.Blocks.Math.Gain gain(k=1/3600)
        annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  equation
    connect(data.y[6], charge_only1.T_condb) annotation (Line(points={{-59,50},{-20,
            50},{-20,-5},{38,-5}}, color={0,0,127}));
    connect(data.y[2], charge_only1.m_eva) annotation (Line(points={{-59,50},{-20,
            50},{-20,-10},{38,-10}}, color={0,0,127}));
    connect(data.y[8], charge_only1.Qdem) annotation (Line(points={{-59,50},{-20,50},
            {-20,-15},{38,-15}}, color={0,0,127}));
    connect(const.y, tank1.T_TES) annotation (Line(points={{1,90},{20,90},{20,40},
            {38,40}}, color={0,0,127}));
    connect(const.y, tank1.T_win) annotation (Line(points={{1,90},{20,90},{20,30},
            {38,30}}, color={0,0,127}));
    connect(const.y, tank1.m_flow) annotation (Line(points={{1,90},{20,90},{20,25},
            {38,25}}, color={0,0,127}));
    connect(charge_only1.Qtes, tank1.Qtes) annotation (Line(points={{61,-10},{80,-10},
            {80,14},{20,14},{20,20},{38,20}}, color={0,0,127}));
    connect(data.y[7], tank1.T_Amb) annotation (Line(points={{-59,50},{-20,50},{-20,
            35},{38,35}}, color={0,0,127}));
    connect(data.y[15], charge_only1.Stes) annotation (Line(points={{-59,50},{-40,
            50},{-40,-20},{38,-20}}, color={0,0,127}));
    connect(data.y[12],gain. u) annotation (Line(points={{-59,50},{-20,50},{-20,
            -50},{-2,-50}},        color={0,0,127}));
    connect(data.y[6], charge_only1.T_evawb) annotation (Line(points={{-59,50},{
            -20,50},{-20,0},{38,0}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      experiment(
        StopTime=31536000,
        Interval=600,
        __Dymola_Algorithm="Dassl"));
  end test_charge;

  model test_discharge
    extends Modelica.Icons.Example;
      BaseClasses.tank tank1
        annotation (Placement(transformation(extent={{40,20},{60,40}})));
    Modelica.Blocks.Sources.CombiTimeTable data(
        tableOnFile=true,
        fileName="D:/dxcoil/cooling_only.txt",
        verboseRead=false,
        columns=2:16,
        tableName="tab1",
        smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
      "Reader for \"CoolingTower_VariableSpeed_Merkel.idf\" energy plus example results"
      annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica.Blocks.Sources.Constant const
        annotation (Placement(transformation(extent={{-20,80},{0,100}})));
      Modelica.Blocks.Math.Gain gain(k=1/3600)
        annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
      BaseClasses.discharge_only discharge_only1
        annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  equation
      connect(const.y, tank1.T_TES) annotation (Line(points={{1,90},{20,90},{20,
              40},{38,40}}, color={0,0,127}));
      connect(const.y, tank1.T_win) annotation (Line(points={{1,90},{20,90},{20,
              30},{38,30}}, color={0,0,127}));
      connect(const.y, tank1.m_flow) annotation (Line(points={{1,90},{20,90},{
              20,25},{38,25}}, color={0,0,127}));
      connect(data.y[6], tank1.T_Amb) annotation (Line(points={{-59,50},{-20,50},
              {-20,35},{38,35}}, color={0,0,127}));
      connect(data.y[5], discharge_only1.T_evawb) annotation (Line(points={{-59,
              50},{-20,50},{-20,0},{38,0}}, color={0,0,127}));
      connect(data.y[4], discharge_only1.T_evadb) annotation (Line(points={{-59,
              50},{-20,50},{-20,-5},{38,-5}}, color={0,0,127}));
      connect(data.y[2], discharge_only1.m_eva) annotation (Line(points={{-59,
              50},{-20,50},{-20,-10},{38,-10}}, color={0,0,127}));
      connect(discharge_only1.Qtes, tank1.Qtes) annotation (Line(points={{61,
              -10},{80,-10},{80,10},{20,10},{20,20},{38,20}}, color={0,0,127}));
      connect(data.y[8], discharge_only1.Qdem) annotation (Line(points={{-59,50},
              {-20,50},{-20,-15},{38,-15}}, color={0,0,127}));
      connect(data.y[15], discharge_only1.Stes) annotation (Line(points={{-59,
              50},{-40,50},{-40,-20},{38,-20}}, color={0,0,127}));
      connect(data.y[12], gain.u) annotation (Line(points={{-59,50},{-20,50},{
              -20,-50},{-2,-50}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
        experiment(
          StopTime=31536000,
          Interval=600,
          __Dymola_Algorithm="Dassl"));
  end test_discharge;


  model complete
    extends Modelica.Icons.Example;
      BaseClasses.all_modes all_modes1
        annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
      BaseClasses.tank tank1
        annotation (Placement(transformation(extent={{20,20},{40,40}})));
    Modelica.Blocks.Sources.CombiTimeTable data(
      tableOnFile=true,
      fileName="D:/dxcoil/cooling_only.txt",
      verboseRead=false,
      columns=2:16,
      tableName="tab1",
      smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
      "Reader for \"CoolingTower_VariableSpeed_Merkel.idf\" energy plus example results"
      annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
    Controls.OBC.CDL.Conversions.RealToInteger reaToInt
      annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
    Modelica.Blocks.Sources.Constant const(k=0)
      annotation (Placement(transformation(extent={{-20,60},{0,80}})));
      Modelica.Blocks.Math.Gain gain(k=1/3600)
        annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  equation
    connect(all_modes1.Qtes, tank1.Qtes) annotation (Line(points={{-19,13},{8,
            13},{8,20},{18,20}}, color={0,0,127}));
    connect(data.y[11], reaToInt.u)
      annotation (Line(points={{-79,70},{-62,70}}, color={0,0,127}));
    connect(reaToInt.y, all_modes1.u) annotation (Line(points={{-38,70},{-30,70},
            {-30,22}}, color={255,127,0}));
    connect(data.y[5], all_modes1.T_evawb) annotation (Line(points={{-79,70},{
            -70,70},{-70,20},{-42,20}}, color={0,0,127}));
    connect(data.y[4], all_modes1.T_evadb) annotation (Line(points={{-79,70},{
            -70,70},{-70,16},{-42,16}}, color={0,0,127}));
    connect(data.y[6], all_modes1.T_condb) annotation (Line(points={{-79,70},{
            -70,70},{-70,12},{-42,12}}, color={0,0,127}));
    connect(data.y[8], all_modes1.Qdem) annotation (Line(points={{-79,70},{-70,
            70},{-70,4},{-42,4}}, color={0,0,127}));
    connect(data.y[7], tank1.T_Amb) annotation (Line(points={{-79,70},{-70,70},
            {-70,35},{18,35}}, color={0,0,127}));
    connect(const.y, tank1.T_TES) annotation (Line(points={{1,70},{10,70},{10,
            40},{18,40}}, color={0,0,127}));
    connect(const.y, tank1.T_win) annotation (Line(points={{1,70},{10,70},{10,
            30},{18,30}}, color={0,0,127}));
    connect(const.y, tank1.m_flow) annotation (Line(points={{1,70},{10,70},{10,
            25},{18,25}}, color={0,0,127}));
      connect(data.y[12],gain. u) annotation (Line(points={{-79,70},{-70,70},{
            -70,-30},{-62,-30}},  color={0,0,127}));
    connect(tank1.Stes, all_modes1.Stes) annotation (Line(points={{41,30},{50,
            30},{50,-10},{-52,-10},{-52,0},{-42,0}}, color={0,0,127}));
      connect(data.y[2], all_modes1.m_eva) annotation (Line(points={{-79,70},{
              -70,70},{-70,8},{-42,8}}, color={0,0,127}));
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
      experiment(
          StopTime=31536000,
          Interval=600,
          __Dymola_Algorithm="Dassl"));
  end complete;

  model complete_pbQtes
    extends Modelica.Icons.Example;
      BaseClasses.all_modes all_modes1
        annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
      BaseClasses.tank tank1
        annotation (Placement(transformation(extent={{20,20},{40,40}})));
    Modelica.Blocks.Sources.CombiTimeTable data(
      tableOnFile=true,
      fileName="D:/dxcoil/cooling_only.txt",
      verboseRead=false,
      columns=2:16,
      tableName="tab1",
      smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
      "Reader for \"CoolingTower_VariableSpeed_Merkel.idf\" energy plus example results"
      annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
    Controls.OBC.CDL.Conversions.RealToInteger reaToInt
      annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
    Modelica.Blocks.Sources.Constant const(k=0)
      annotation (Placement(transformation(extent={{-20,60},{0,80}})));
      Modelica.Blocks.Math.Gain gain(k=1/3600)
        annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
      Controls.OBC.CDL.Reals.Switch swi
        annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
      Controls.OBC.CDL.Integers.LessThreshold intLesThr(t=5)
        annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
      Modelica.Blocks.Math.Gain gain1(k=-1)
        annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  equation
    connect(data.y[11], reaToInt.u)
      annotation (Line(points={{-79,70},{-62,70}}, color={0,0,127}));
    connect(reaToInt.y, all_modes1.u) annotation (Line(points={{-38,70},{-30,70},
            {-30,22}}, color={255,127,0}));
    connect(data.y[5], all_modes1.T_evawb) annotation (Line(points={{-79,70},{
            -70,70},{-70,20},{-42,20}}, color={0,0,127}));
    connect(data.y[4], all_modes1.T_evadb) annotation (Line(points={{-79,70},{
            -70,70},{-70,16},{-42,16}}, color={0,0,127}));
    connect(data.y[6], all_modes1.T_condb) annotation (Line(points={{-79,70},{
            -70,70},{-70,12},{-42,12}}, color={0,0,127}));
    connect(data.y[8], all_modes1.Qdem) annotation (Line(points={{-79,70},{-70,
            70},{-70,4},{-42,4}}, color={0,0,127}));
    connect(data.y[7], tank1.T_Amb) annotation (Line(points={{-79,70},{-70,70},
            {-70,35},{18,35}}, color={0,0,127}));
    connect(const.y, tank1.T_TES) annotation (Line(points={{1,70},{10,70},{10,
            40},{18,40}}, color={0,0,127}));
    connect(const.y, tank1.T_win) annotation (Line(points={{1,70},{10,70},{10,
            30},{18,30}}, color={0,0,127}));
    connect(const.y, tank1.m_flow) annotation (Line(points={{1,70},{10,70},{10,
            25},{18,25}}, color={0,0,127}));
      connect(data.y[12],gain. u) annotation (Line(points={{-79,70},{-70,70},{
            -70,-30},{-62,-30}},  color={0,0,127}));
    connect(tank1.Stes, all_modes1.Stes) annotation (Line(points={{41,30},{50,
            30},{50,-10},{-52,-10},{-52,0},{-42,0}}, color={0,0,127}));
      connect(swi.y, tank1.Qtes) annotation (Line(points={{22,-60},{30,-60},{30,
              10},{10,10},{10,20},{18,20}}, color={0,0,127}));
      connect(all_modes1.Qtes, swi.u1) annotation (Line(points={{-19,13},{-10,
              13},{-10,-52},{-2,-52}}, color={0,0,127}));
      connect(intLesThr.y, swi.u2)
        annotation (Line(points={{-18,-60},{-2,-60}}, color={255,0,255}));
      connect(reaToInt.y, intLesThr.u) annotation (Line(points={{-38,70},{-30,
              70},{-30,40},{-80,40},{-80,-60},{-42,-60}}, color={255,127,0}));
      connect(gain1.y, swi.u3) annotation (Line(points={{-19,-90},{-10,-90},{
              -10,-68},{-2,-68}}, color={0,0,127}));
      connect(data.y[13], gain1.u) annotation (Line(points={{-79,70},{-70,70},{
              -70,-90},{-42,-90}}, color={0,0,127}));
      connect(data.y[2], all_modes1.m_eva) annotation (Line(points={{-79,70},{
              -70,70},{-70,8},{-42,8}}, color={0,0,127}));
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
      experiment(
        StopTime=31536000,
        Interval=600,
        __Dymola_Algorithm="Dassl"));
  end complete_pbQtes;

  model rtu_test
    extends Modelica.Icons.Example;
      BaseClasses.all_modes all_modes1
        annotation (Placement(transformation(extent={{0,0},{20,20}})));
      BaseClasses.tank tank1
        annotation (Placement(transformation(extent={{60,20},{80,40}})));
    Modelica.Blocks.Sources.CombiTimeTable data(
        tableOnFile=true,
        fileName="D:/dxcoil/cooling_only.txt",
        verboseRead=false,
        columns=2:16,
        tableName="tab1",
        smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
      "Reader for \"CoolingTower_VariableSpeed_Merkel.idf\" energy plus example results"
      annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
    Controls.OBC.CDL.Conversions.RealToInteger reaToInt
      annotation (Placement(transformation(extent={{-20,60},{0,80}})));
    Modelica.Blocks.Sources.Constant const(k=0)
      annotation (Placement(transformation(extent={{20,60},{40,80}})));
      Modelica.Blocks.Math.Gain gain(k=1/3600)
        annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
      rtu rtu1 annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  equation
    connect(all_modes1.Qtes,tank1. Qtes) annotation (Line(points={{21,13},{48,
              13},{48,20},{58,20}},
                                 color={0,0,127}));
    connect(data.y[11],reaToInt. u)
      annotation (Line(points={{-59,70},{-22,70}}, color={0,0,127}));
    connect(reaToInt.y,all_modes1. u) annotation (Line(points={{2,70},{10,70},{
              10,22}}, color={255,127,0}));
    connect(data.y[5],all_modes1. T_evawb) annotation (Line(points={{-59,70},{
              -50,70},{-50,20},{-2,20}},color={0,0,127}));
    connect(data.y[4],all_modes1. T_evadb) annotation (Line(points={{-59,70},{
              -50,70},{-50,20},{-10,20},{-10,16},{-2,16}},
                                        color={0,0,127}));
    connect(data.y[6],all_modes1. T_condb) annotation (Line(points={{-59,70},{
              -50,70},{-50,20},{-10,20},{-10,12},{-2,12}},
                                        color={0,0,127}));
    connect(data.y[8],all_modes1. Qdem) annotation (Line(points={{-59,70},{-50,
              70},{-50,20},{-10,20},{-10,4},{-2,4}},
                                  color={0,0,127}));
    connect(data.y[7],tank1. T_Amb) annotation (Line(points={{-59,70},{-50,70},
              {-50,20},{-10,20},{-10,32},{18,32},{18,35},{58,35}},
                               color={0,0,127}));
    connect(const.y,tank1. T_TES) annotation (Line(points={{41,70},{50,70},{50,
              40},{58,40}},
                          color={0,0,127}));
    connect(const.y,tank1. T_win) annotation (Line(points={{41,70},{50,70},{50,
              30},{58,30}},
                          color={0,0,127}));
    connect(const.y,tank1. m_flow) annotation (Line(points={{41,70},{50,70},{50,
              25},{58,25}},
                          color={0,0,127}));
      connect(data.y[12],gain. u) annotation (Line(points={{-59,70},{-50,70},{
              -50,-70},{-42,-70}},color={0,0,127}));
    connect(tank1.Stes,all_modes1. Stes) annotation (Line(points={{81,30},{86,
              30},{86,-8},{-10,-8},{-10,0},{-2,0}},  color={0,0,127}));
      connect(data.y[2],all_modes1. m_eva) annotation (Line(points={{-59,70},{
              -50,70},{-50,20},{-10,20},{-10,8},{-2,8}},
                                        color={0,0,127}));
      connect(data.y[5], rtu1.T_evawb) annotation (Line(points={{-59,70},{-50,
              70},{-50,-24},{-10,-24},{-10,-20},{-2,-20},{-2,-21}}, color={0,0,
              127}));
      connect(data.y[4], rtu1.T_evadb) annotation (Line(points={{-59,70},{-50,
              70},{-50,-24},{-2,-24}}, color={0,0,127}));
      connect(data.y[6], rtu1.T_condb) annotation (Line(points={{-59,70},{-50,
              70},{-50,-24},{-10,-24},{-10,-27},{-2,-27}}, color={0,0,127}));
      connect(data.y[2], rtu1.m_eva) annotation (Line(points={{-59,70},{-50,70},
              {-50,-24},{-10,-24},{-10,-30},{-2,-30}}, color={0,0,127}));
      connect(data.y[8], rtu1.Qdem) annotation (Line(points={{-59,70},{-50,70},
              {-50,-24},{-10,-24},{-10,-33},{-2,-33}}, color={0,0,127}));
      connect(data.y[11], rtu1.mode) annotation (Line(points={{-59,70},{-50,70},
              {-50,-24},{-10,-24},{-10,-36},{-2,-36}}, color={0,0,127}));
      connect(data.y[7], rtu1.T_Amb) annotation (Line(points={{-59,70},{-50,70},
              {-50,-24},{-10,-24},{-10,-39},{-2,-39}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
        experiment(
          StopTime=31536000,
          Interval=600,
          __Dymola_Algorithm="Dassl"));
  end rtu_test;
end Validation;

  annotation (Icon(graphics={
                          Line(points={{0,80},{0,-80}},   color={0,128,255},
          thickness=0.5,
          rotation=180),
        Line(
          points={{-40,68},{0,32},{40,68}},
          color={0,128,255},
          thickness=0.5),
        Line(
          points={{-40,-68},{0,-32},{40,-68}},
          color={0,128,255},
          thickness=0.5),
        Line(
          points={{-40,-20},{-1.83697e-15,16},{40,-20}},
          color={0,128,255},
          thickness=0.5,
          origin={48,0},
          rotation=90),
        Line(
          points={{-40,20},{1.83697e-15,-16},{40,20}},
          color={0,128,255},
          thickness=0.5,
          origin={-48,0},
          rotation=90),   Line(points={{0,80},{0,-80}},   color={0,128,255},
          thickness=0.5,
          rotation=270)}));
end dxsto;
