within Buildings.Fluid.HeatExchangers.DXCoils.Data;
package DoubleSpeed "Performance data for DoubleSpeed DXCoils"
  extends Modelica.Icons.MaterialPropertiesPackage;
 annotation(
 preferredView="info",
  Documentation(info="<html>
<p>
Package with performance data for DX coils.
</p>
</html>",
 revisions="<html>
<p>
Generated on 12/19/2014 15:08 by tsnouidui.
</p>
</html>"));
  record Generic "Generic data record for DoubleSpeed DXCoils"
    extends Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.DXCoil(final nSta=2);
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>
This record is used as a template for performance data
for the double speed DX coils
<a href=\"Buildings.Fluid.HeatExchangers.DXCoils.DoubleSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.DoubleSpeed</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 20, 2012 by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"));
  end Generic;

  record  Lennox_KCA120S4 =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.DoubleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe = 1200,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -17193.23,
      COP_nominal =           3.54,
      SHR_nominal =           0.69,
      m_flow_nominal =        1.2*1.888),
      perCur =
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {0.6383427,0.0368605,-0.0002156,-0.0032619,-0.0000414,-0.0001587},
      capFunFF =             {0.6422487,0.5494037,-0.1916525},
      EIRFunT =              {0.6609961,-0.0173045,0.0003871,0.0121825,0.0003430,-0.0004676},
      EIRFunFF =             {1.3016695,-0.4659596,0.1642901},
      TConInMin =            273.15 + 18.33,
      TConInMax =            273.15 + 35,
      TEvaInMin =            273.15 + 17.22,
      TEvaInMax =            273.15 + 21.67,
      ffMin =                0.8,
      ffMax =                1.2)),
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe = 1200*35235.87/17193.23,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -35235.87,
      COP_nominal =           3.88,
      SHR_nominal =           0.72,
      m_flow_nominal =        1.2*1.888),
      perCur =
         Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {0.6803326,0.0268925,0.0001473,0.0003186,-0.0000584,-0.0002929},
      capFunFF =             {0.6716542,0.4945968,-0.1662510},
      EIRFunT =              {0.7758738,-0.0051500,0.0002254,-0.0042810,0.0006657,-0.0006284},
      EIRFunFF =             {1.2812519,-0.4288495,0.1475977},
      TConInMin =            273.15 + 29.44,
      TConInMax =            273.15 + 46.11,
      TEvaInMin =            273.15 + 17.22,
      TEvaInMax =            273.15 + 21.67,
      ffMin =                0.8,
      ffMax =                1.2))
})"Lennox KCA120S4"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>
Performance data for double speed cooling coil model.
This data corresponds to the following EnergyPlus model:</p>
<pre>
Coil:Cooling:DX:TwoStageWithHumidityControlMode,
    Lennox KCA120S4,               !- Name
    CoolingCoilAvailSched,         !- Availability Schedule Name
    DXCoilAirInletNode,            !- Air Inlet Node Name
    DXCoilAirOutletNode,           !- Air Outlet Node Name
    ,                              !- Crankcase Heater Capacity {W}
    ,                              !- Maximum Outdoor Dry-Bulb Temperature for Crankcase Heater Operation {C}
    2,                             !- Number of Capacity Stages
    0,                             !- Number of Enhanced Dehumidification Modes
    CoilPerformance:DX:Cooling,    !- Normal Mode Stage 1 Coil Performance Object Type
    Lennox KCA120S4 Stage 1,       !- Normal Mode Stage 1 Coil Performance Name
    CoilPerformance:DX:Cooling,    !- Normal Mode Stage 1+2 Coil Performance Object Type
    Lennox KCA120S4 Stage 1&amp;2;     !- Normal Mode Stage 1+2 Coil Performance Name
</pre>
</html>"));

  record  Lennox_KCA240S4 =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.DoubleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe = 1200,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -46951.87,
      COP_nominal =           3.74,
      SHR_nominal =           0.75,
      m_flow_nominal =        1.2*3.776),
      perCur =
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {0.6774110,0.0279341,0.0001421,-0.0020862,-0.0000337,-0.0002350},
      capFunFF =             {0.6631316,0.4928260,-0.1559576},
      EIRFunT =              {0.7433676,-0.0189703,0.0003270,0.0118669,0.0003111,-0.0004329},
      EIRFunFF =             {1.3251503,-0.4910623,0.1659119},
      TConInMin =            273.15 + 18.33,
      TConInMax =            273.15 + 35,
      TEvaInMin =            273.15 + 17.22,
      TEvaInMax =            273.15 + 21.67,
      ffMin =                0.8,
      ffMax =                1.2)),
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe = 1200*69944.52/46951.87,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -69944.52,
      COP_nominal =           3.83,
      SHR_nominal =           0.78,
      m_flow_nominal =        1.2*3.776),
      perCur =
         Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {0.8015587,0.0136475,0.0005406,-0.0001875,-0.0000475,-0.0003036},
      capFunFF =             {0.6880235,0.4533082,-0.1413317},
      EIRFunT =              {0.6483859,0.0034675,-0.0000671,0.0026918,0.0005166,-0.0006149},
      EIRFunFF =             {1.2930771,-0.4396936,0.1466166},
      TConInMin =            273.15 + 29.44,
      TConInMax =            273.15 + 46.11,
      TEvaInMin =            273.15 + 17.22,
      TEvaInMax =            273.15 + 21.67,
      ffMin =                0.8,
      ffMax =                1.2))
})"Lennox KCA240S4"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>
Performance data for double speed cooling coil model.
This data corresponds to the following EnergyPlus model:</p>
<pre>
Coil:Cooling:DX:TwoStageWithHumidityControlMode,
    Lennox KCA240S4,               !- Name
    CoolingCoilAvailSched,         !- Availability Schedule Name
    DXCoilAirInletNode,            !- Air Inlet Node Name
    DXCoilAirOutletNode,           !- Air Outlet Node Name
    ,                              !- Crankcase Heater Capacity {W}
    ,                              !- Maximum Outdoor Dry-Bulb Temperature for Crankcase Heater Operation {C}
    2,                             !- Number of Capacity Stages
    0,                             !- Number of Enhanced Dehumidification Modes
    CoilPerformance:DX:Cooling,    !- Normal Mode Stage 1 Coil Performance Object Type
    Lennox KCA240S4 Stage 1,       !- Normal Mode Stage 1 Coil Performance Name
    CoilPerformance:DX:Cooling,    !- Normal Mode Stage 1+2 Coil Performance Object Type
    Lennox KCA240S4 Stage 1&amp;2;     !- Normal Mode Stage 1+2 Coil Performance Name
</pre>
</html>"));

  record  Lennox_SCA120H4B =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.DoubleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe = 1200,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -18218.38,
      COP_nominal =           4.09,
      SHR_nominal =           0.67,
      m_flow_nominal =        1.2*1.888),
      perCur =
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {0.8197084,0.0064733,0.0008546,0.0002134,-0.0000477,-0.0003191},
      capFunFF =             {0.7266881,0.3938907,-0.1205788},
      EIRFunT =              {0.6505692,-0.0124024,0.0001183,0.0144585,0.0003194,-0.0005187},
      EIRFunFF =             {1.2512370,-0.3652365,0.1139994},
      TConInMin =            273.15 + 18.33,
      TConInMax =            273.15 + 35,
      TEvaInMin =            273.15 + 17.22,
      TEvaInMax =            273.15 + 21.67,
      ffMin =                0.8,
      ffMax =                1.2)),
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe = 1200*36436.76/18218.38,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -36436.76,
      COP_nominal =           4.35,
      SHR_nominal =           0.73,
      m_flow_nominal =        1.2*1.888),
      perCur =
         Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {0.9438524,-0.0094097,0.0013226,0.0038157,-0.0000608,-0.0004721},
      capFunFF =             {0.7266881,0.4139871,-0.1406752},
      EIRFunT =              {0.5476528,0.0268762,-0.0007716,-0.0070535,0.0006878,-0.0005488},
      EIRFunFF =             {1.2731734,-0.4301446,0.1569712},
      TConInMin =            273.15 + 29.44,
      TConInMax =            273.15 + 46.11,
      TEvaInMin =            273.15 + 17.22,
      TEvaInMax =            273.15 + 21.67,
      ffMin =                0.8,
      ffMax =                1.2))
})"Lennox SCA120H4B"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>
Performance data for double speed cooling coil model.
This data corresponds to the following EnergyPlus model:</p>
<pre>
Coil:Cooling:DX:TwoStageWithHumidityControlMode,
    Lennox SCA120H4B,               !- Name
    CoolingCoilAvailSched,          !- Availability Schedule Name
    DXCoilAirInletNode,             !- Air Inlet Node Name
    DXCoilAirOutletNode,            !- Air Outlet Node Name
    ,                               !- Crankcase Heater Capacity {W}
    ,                               !- Maximum Outdoor Dry-Bulb Temperature for Crankcase Heater Operation {C}
    2,                              !- Number of Capacity Stages
    0,                              !- Number of Enhanced Dehumidification Modes
    CoilPerformance:DX:Cooling,     !- Normal Mode Stage 1 Coil Performance Object Type
    Lennox SCA120H4B Stage 1,       !- Normal Mode Stage 1 Coil Performance Name
    CoilPerformance:DX:Cooling,     !- Normal Mode Stage 1+2 Coil Performance Object Type
    Lennox SCA120H4B Stage 1&amp;2;     !- Normal Mode Stage 1+2 Coil Performance Name
</pre>
</html>"));

  record  Lennox_SCA240H4B =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.DoubleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe = 1200,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -35411.61,
      COP_nominal =           3.76,
      SHR_nominal =           0.71,
      m_flow_nominal =        1.2*3.776),
      perCur =
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {1.0046573,-0.0098458,0.0011934,-0.0002426,-0.0000424,-0.0002981},
      capFunFF =             {0.8014888,0.2708850,-0.0723739},
      EIRFunT =              {0.5020269,0.0044036,-0.0003075,0.0120302,0.0003200,-0.0004203},
      EIRFunFF =             {1.1811735,-0.2541256,0.0729521},
      TConInMin =            273.15 + 18.33,
      TConInMax =            273.15 + 35,
      TEvaInMin =            273.15 + 17.22,
      TEvaInMax =            273.15 + 21.67,
      ffMin =                0.8,
      ffMax =                1.2)),
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe = 1200*72873.52/35411.61,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -72873.52,
      COP_nominal =           4.26,
      SHR_nominal =           0.77,
      m_flow_nominal =        1.2*3.776),
      perCur =
         Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {0.9947501,-0.0138816,0.0013836,0.0028728,-0.0000586,-0.0004070},
      capFunFF =             {0.7729100,0.3275723,-0.1004823},
      EIRFunT =              {0.4914020,0.0298133,-0.0007899,-0.0052059,0.0006735,-0.0006127},
      EIRFunFF =             {1.1954441,-0.2809494,0.0855053},
      TConInMin =            273.15 + 29.44,
      TConInMax =            273.15 + 46.11,
      TEvaInMin =            273.15 + 17.22,
      TEvaInMax =            273.15 + 21.67,
      ffMin =                0.8,
      ffMax =                1.2))
})"Lennox SCA240H4B"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>
Performance data for double speed cooling coil model.
This data corresponds to the following EnergyPlus model:</p>
<pre>
Coil:Cooling:DX:TwoStageWithHumidityControlMode,
    Lennox SCA240H4B,               !- Name
    CoolingCoilAvailSched,          !- Availability Schedule Name
    DXCoilAirInletNode,             !- Air Inlet Node Name
    DXCoilAirOutletNode,            !- Air Outlet Node Name
    ,                               !- Crankcase Heater Capacity {W}
    ,                               !- Maximum Outdoor Dry-Bulb Temperature for Crankcase Heater Operation {C}
    2,                              !- Number of Capacity Stages
    0,                              !- Number of Enhanced Dehumidification Modes
    CoilPerformance:DX:Cooling,     !- Normal Mode Stage 1 Coil Performance Object Type
    Lennox SCA240H4B Stage 1,       !- Normal Mode Stage 1 Coil Performance Name
    CoilPerformance:DX:Cooling,     !- Normal Mode Stage 1+2 Coil Performance Object Type
    Lennox SCA240H4B Stage 1&amp;2;     !- Normal Mode Stage 1+2 Coil Performance Name
</pre>
</html>"));

  record  Lennox_TCA120S =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.DoubleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe = 1200,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -18276.96,
      COP_nominal =           3.54,
      SHR_nominal =           0.71,
      m_flow_nominal =        1.2*1.888),
      perCur =
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {0.9945773,-0.0149279,0.0011358,0.0023510,-0.0001038,-0.0001298},
      capFunFF =             {0.7756410,0.3245192,-0.1001603},
      EIRFunT =              {0.6121724,0.0075378,-0.0002892,0.0056946,0.0003564,-0.0004210},
      EIRFunFF =             {1.1786830,-0.2662820,0.0875989},
      TConInMin =            273.15 + 18.33,
      TConInMax =            273.15 + 35,
      TEvaInMin =            273.15 + 17.22,
      TEvaInMax =            273.15 + 21.67,
      ffMin =                0.8,
      ffMax =                1.2)),
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe = 1200*37139.72/18276.96,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -37139.72,
      COP_nominal =           3.68,
      SHR_nominal =           0.72,
      m_flow_nominal =        1.2*1.888),
      perCur =
         Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {1.0746975,-0.0187470,0.0013175,-0.0005737,-0.0000298,-0.0002236},
      capFunFF =             {0.7752366,0.3233438,-0.0985804},
      EIRFunT =              {0.4749267,0.0251138,-0.0006690,0.0021468,0.0004483,-0.0004911},
      EIRFunFF =             {1.2030577,-0.3137318,0.1106741},
      TConInMin =            273.15 + 29.44,
      TConInMax =            273.15 + 46.11,
      TEvaInMin =            273.15 + 17.22,
      TEvaInMax =            273.15 + 21.67,
      ffMin =                0.8,
      ffMax =                1.2))
})"Lennox TCA120S"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>
Performance data for double speed cooling coil model.
This data corresponds to the following EnergyPlus model:</p>
<pre>
Coil:Cooling:DX:TwoStageWithHumidityControlMode,
    Lennox TCA120S,                !- Name
    CoolingCoilAvailSched,         !- Availability Schedule Name
    DXCoilAirInletNode,            !- Air Inlet Node Name
    DXCoilAirOutletNode,           !- Air Outlet Node Name
    ,                              !- Crankcase Heater Capacity {W}
    ,                              !- Maximum Outdoor Dry-Bulb Temperature for Crankcase Heater Operation {C}
    2,                             !- Number of Capacity Stages
    0,                             !- Number of Enhanced Dehumidification Modes
    CoilPerformance:DX:Cooling,    !- Normal Mode Stage 1 Coil Performance Object Type
    Lennox TCA120S Stage 1,        !- Normal Mode Stage 1 Coil Performance Name
    CoilPerformance:DX:Cooling,    !- Normal Mode Stage 1+2 Coil Performance Object Type
    Lennox TCA120S Stage 1&amp;2;      !- Normal Mode Stage 1+2 Coil Performance Name
</pre>
</html>"));

  record  Lennox_TCA240S =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.DoubleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe = 1200,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -49207.2,
      COP_nominal =           3.47,
      SHR_nominal =           0.71,
      m_flow_nominal =        1.2*3.776),
      perCur =
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {0.9914722,-0.0108810,0.0010999,-0.0007210,-0.0000305,-0.0001953},
      capFunFF =             {0.7797619,0.3244048,-0.1041667},
      EIRFunT =              {0.5325300,0.0033859,-0.0001823,0.0107895,0.0003050,-0.0004131},
      EIRFunFF =             {1.1888341,-0.2942931,0.1054590},
      TConInMin =            273.15 + 18.33,
      TConInMax =            273.15 + 35,
      TEvaInMin =            273.15 + 17.22,
      TEvaInMax =            273.15 + 21.67,
      ffMin =                0.8,
      ffMax =                1.2)),
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe = 1200*71174.7/49207.2,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -71174.7,
      COP_nominal =           3.45,
      SHR_nominal =           0.77,
      m_flow_nominal =        1.2*3.776),
      perCur =
         Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {1.0116786,-0.0156968,0.0012604,0.0009509,-0.0000422,-0.0002417},
      capFunFF =             {0.7860082,0.3117284,-0.0977366},
      EIRFunT =              {0.6088217,0.0104053,-0.0002803,0.0009889,0.0004927,-0.0005063},
      EIRFunFF =             {1.1739773,-0.2636802,0.0897028},
      TConInMin =            273.15 + 29.44,
      TConInMax =            273.15 + 46.11,
      TEvaInMin =            273.15 + 17.22,
      TEvaInMax =            273.15 + 21.67,
      ffMin =                0.8,
      ffMax =                1.2))
})"Lennox TCA240S"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>
Performance data for double speed cooling coil model.
This data corresponds to the following EnergyPlus model:</p>
<pre>
Coil:Cooling:DX:TwoStageWithHumidityControlMode,
    Lennox TCA240S,               !- Name
    CoolingCoilAvailSched,        !- Availability Schedule Name
    DXCoilAirInletNode,           !- Air Inlet Node Name
    DXCoilAirOutletNode,          !- Air Outlet Node Name
    ,                             !- Crankcase Heater Capacity {W}
    ,                             !- Maximum Outdoor Dry-Bulb Temperature for Crankcase Heater Operation {C}
    2,                            !- Number of Capacity Stages
    0,                            !- Number of Enhanced Dehumidification Modes
    CoilPerformance:DX:Cooling,   !- Normal Mode Stage 1 Coil Performance Object Type
    Lennox TCA240S Stage 1,       !- Normal Mode Stage 1 Coil Performance Name
    CoilPerformance:DX:Cooling,   !- Normal Mode Stage 1+2 Coil Performance Object Type
    Lennox TCA240S Stage 1&amp;2;     !- Normal Mode Stage 1+2 Coil Performance Name
</pre>
</html>"));

end DoubleSpeed;
