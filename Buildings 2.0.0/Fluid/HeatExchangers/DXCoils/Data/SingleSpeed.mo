within Buildings.Fluid.HeatExchangers.DXCoils.Data;
package SingleSpeed "Performance data for SingleSpeed DXCoils"
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
  record Generic "Generic data record for SingleSpeed DXCoils"
    extends Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.DXCoil(final nSta=1);
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>
This record is used as a template for performance data
for SingleSpeed DXCoils
<a href=\"Buildings.Fluid.HeatExchangers.DXCoils.SingleSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.SingleSpeed</a>.
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

  record  Lennox_KCA060S4 =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe=1800,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -18101.22,
      COP_nominal =           4.07,
      SHR_nominal =           0.72,
      m_flow_nominal =        1.2*0.944),
      perCur =
      Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {0.9600147,-0.0106038,0.0013516,0.0039357,-0.0000568,-0.0004915},
      capFunFF =             {0.7491909,0.3721683,-0.1213592},
      EIRFunT =              {0.2484029,0.0610633,-0.0017081,-0.0102658,0.0007028,-0.0004237},
      EIRFunFF =             {1.2094575,-0.3165036,0.1070461},
      TConInMin =            273.15 + 18.33,
      TConInMax =            273.15 + 35,
      TEvaInMin =            273.15 + 17.22,
      TEvaInMax =            273.15 + 29.44,
      ffMin =                0.8,
      ffMax =                1.2))})
"Lennox KCA060S4"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>Performance data for DX single speed cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    Lennox KCA060S4,         !- Name
    CoolingCoilAvailSched,   !- Availability Schedule Name
    18101.22,                !- Rated Total Cooling Capacity {W}
    0.72,                    !- Rated Sensible Heat Ratio
    4.07,                    !- Rated COP
    0.944,                   !- Rated Air Flow Rate {m3/s}
    ,                        !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,      !- Air Inlet Node Name
    DXCoilAirOutletNode,     !- Air Outlet Node Name
    Lennox KCA060S4 CapFT,   !- Total Cooling Capacity Function of Temperature Curve Name
    Lennox KCA060S4 CapFFF,  !- Total Cooling Capacity Function of Flow Fraction Curve Name
    Lennox KCA060S4 EIRFT,   !- Energy Input Ratio Function of Temperature Curve Name
    Lennox KCA060S4 EIRFFF,  !- Energy Input Ratio Function of Flow Fraction Curve Name
    Lennox KCA060S4 PLFFPLR; !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));

  record  Lennox_SCA060H4B =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe=1800,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -18452.7,
      COP_nominal =           4.48,
      SHR_nominal =           0.73,
      m_flow_nominal =        1.2*0.944),
      perCur =
      Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {1.0671319,-0.0218036,0.0016875,0.0054500,-0.0000643,-0.0005786},
      capFunFF =             {0.8174603,0.2420635,-0.0595238},
      EIRFunT =              {0.4618717,0.0448432,-0.0012979,-0.0158459,0.0007680,-0.0003382},
      EIRFunFF =             {0.9342105,0.0986842,-0.0328947},
      TConInMin =            273.15 + 29.44,
      TConInMax =            273.15 + 46.11,
      TEvaInMin =            273.15 + 17.22,
      TEvaInMax =            273.15 + 21.67,
      ffMin =                0.8,
      ffMax =                1.2))})
"Lennox SCA060H4B"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>Performance data for DX single speed cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    Lennox SCA060H4B,              !- Name
    CoolingCoilAvailSched,         !- Availability Schedule Name
    18452.7,                       !- Rated Total Cooling Capacity {W}
    0.73,                          !- Rated Sensible Heat Ratio
    4.48,                          !- Rated COP
    0.944,                         !- Rated Air Flow Rate {m3/s}
    ,                              !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,            !- Air Inlet Node Name
    DXCoilAirOutletNode,           !- Air Outlet Node Name
    Lennox SCA060H4B CapFT,        !- Total Cooling Capacity Function of Temperature Curve Name
    Lennox SCA060H4B CapFFF,       !- Total Cooling Capacity Function of Flow Fraction Curve Name
    Lennox SCA060H4B EIRFT,        !- Energy Input Ratio Function of Temperature Curve Name
    Lennox SCA060H4B EIRFFF,       !- Energy Input Ratio Function of Flow Fraction Curve Name
    Lennox SCA060H4B PLFFPLR;      !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));

  record  Lennox_TCA060S2 =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe=1800,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -18452.7,
      COP_nominal =           4.07,
      SHR_nominal =           0.75,
      m_flow_nominal =        1.2*0.944),
      perCur =
      Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {0.9274018,-0.0049893,0.0010446,0.0003500,-0.0000300,-0.0002957},
      capFunFF =             {0.7539683,0.3650794,-0.1190476},
      EIRFunT =              {0.5480534,0.0256216,-0.0006559,-0.0031147,0.0006074,-0.0006367},
      EIRFunFF =             {1.0120192,-0.0420673,0.0300481},
      TConInMin =            273.15 + 29.44,
      TConInMax =            273.15 + 46.11,
      TEvaInMin =            273.15 + 17.22,
      TEvaInMax =            273.15 + 21.67,
      ffMin =                0.8,
      ffMax =                1.2))})
"Lennox TCA060S2"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>Performance data for DX single speed cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    Lennox TCA060S2,               !- Name
    CoolingCoilAvailSched,         !- Availability Schedule Name
    18452.7,                       !- Rated Total Cooling Capacity {W}
    0.75,                          !- Rated Sensible Heat Ratio
    4.07,                          !- Rated COP
    0.944,                         !- Rated Air Flow Rate {m3/s}
    ,                              !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,            !- Air Inlet Node Name
    DXCoilAirOutletNode,           !- Air Outlet Node Name
    Lennox TCA060S2 CapFT,         !- Total Cooling Capacity Function of Temperature Curve Name
    Lennox TCA060S2 CapFFF,        !- Total Cooling Capacity Function of Flow Fraction Curve Name
    Lennox TCA060S2 EIRFT,         !- Energy Input Ratio Function of Temperature Curve Name
    Lennox TCA060S2 EIRFFF,        !- Energy Input Ratio Function of Flow Fraction Curve Name
    Lennox TCA060S2 PLFFPLR;       !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));

  record  Carrier_Centurion_50PG06 =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe=1800,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -18276.96,
      COP_nominal =           4.15,
      SHR_nominal =           0.74,
      m_flow_nominal =        1.2*0.944),
      perCur =
      Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {0.9953455,-0.0118418,0.0012277,0.0030246,-0.0000702,-0.0003685},
      capFunFF =             {0.7705358,0.2848007,-0.0580891},
      EIRFunT =              {0.3802131,0.0199468,-0.0006682,0.0058933,0.0004646,-0.0004072},
      EIRFunFF =             {1.3439758,-0.5111244,0.1732549},
      TConInMin =            273.15 + 15.56,
      TConInMax =            273.15 + 51.67,
      TEvaInMin =            273.15 + 12.22,
      TEvaInMax =            273.15 + 26.67,
      ffMin =                0.75,
      ffMax =                1.25))})
"Carrier Centurion 50PG06"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>Performance data for DX single speed cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    Carrier Centurion 50PG06,              !- Name
    CoolingCoilAvailSched,                 !- Availability Schedule Name
    18276.96,                              !- Rated Total Cooling Capacity {W}
    0.74,                                  !- Rated Sensible Heat Ratio
    4.15,                                  !- Rated COP
    0.944,                                 !- Rated Air Flow Rate {m3/s}
    ,                                      !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,                    !- Air Inlet Node Name
    DXCoilAirOutletNode,                   !- Air Outlet Node Name
    Carrier Centurion 50PG06 CapFT,        !- Total Cooling Capacity Function of Temperature Curve Name
    Carrier Centurion 50PG06 CapFFF,       !- Total Cooling Capacity Function of Flow Fraction Curve Name
    Carrier Centurion 50PG06 EIRFT,        !- Energy Input Ratio Function of Temperature Curve Name
    Carrier Centurion 50PG06 EIRFFF,       !- Energy Input Ratio Function of Flow Fraction Curve Name
    Carrier Centurion 50PG06 PLFFPLR;      !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));

  record  Carrier_Centurion_50PG12 =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe=1800,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -36788.24,
      COP_nominal =           4.05,
      SHR_nominal =           0.76,
      m_flow_nominal =        1.2*1.888),
      perCur =
      Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {1.0013476,-0.0187754,0.0015312,0.0054931,-0.0000901,-0.0004408},
      capFunFF =             {0.6460191,0.5455414,-0.1910828},
      EIRFunT =              {0.3037085,0.0310288,-0.0009543,0.0053687,0.0004729,-0.0004469},
      EIRFunFF =             {1.3637624,-0.5775338,0.2130374},
      TConInMin =            273.15 + 15.56,
      TConInMax =            273.15 + 51.67,
      TEvaInMin =            273.15 + 12.22,
      TEvaInMax =            273.15 + 26.67,
      ffMin =                0.75,
      ffMax =                1.25))})
"Carrier Centurion 50PG12"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>Performance data for DX single speed cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    Carrier Centurion 50PG12,               !- Name
    CoolingCoilAvailSched,                  !- Availability Schedule Name
    36788.24,                               !- Rated Total Cooling Capacity {W}
    0.76,                                   !- Rated Sensible Heat Ratio
    4.05,                                   !- Rated COP
    1.888,                                  !- Rated Air Flow Rate {m3/s}
    ,                                       !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,                     !- Air Inlet Node Name
    DXCoilAirOutletNode,                    !- Air Outlet Node Name
    Carrier Centurion 50PG12 CapFT,         !- Total Cooling Capacity Function of Temperature Curve Name
    Carrier Centurion 50PG12 CapFFF,        !- Total Cooling Capacity Function of Flow Fraction Curve Name
    Carrier Centurion 50PG12 EIRFT,         !- Energy Input Ratio Function of Temperature Curve Name
    Carrier Centurion 50PG12 EIRFFF,        !- Energy Input Ratio Function of Flow Fraction Curve Name
    Carrier Centurion 50PG12 PLFFPLR;       !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));

  record  Carrier_Centurion_50PG24 =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe=1800,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -73810.8,
      COP_nominal =           3.95,
      SHR_nominal =           0.71,
      m_flow_nominal =        1.2*3.776),
      perCur =
      Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {0.5781158,0.0405917,0.0000113,-0.0095022,0.0000001,-0.0000573},
      capFunFF =             {0.8328798,0.2403628,-0.0725624},
      EIRFunT =              {0.5909553,-0.0496529,0.0016569,0.0397786,0.0003938,-0.0016575},
      EIRFunFF =             {1.0440554,-0.0701720,0.0258826},
      TConInMin =            273.15 + 15.56,
      TConInMax =            273.15 + 51.67,
      TEvaInMin =            273.15 + 12.22,
      TEvaInMax =            273.15 + 26.67,
      ffMin =                0.75,
      ffMax =                1.25))})
"Carrier Centurion 50PG24"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>Performance data for DX single speed cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    Carrier Centurion 50PG24,              !- Name
    CoolingCoilAvailSched,                 !- Availability Schedule Name
    73810.8,                               !- Rated Total Cooling Capacity {W}
    0.71,                                  !- Rated Sensible Heat Ratio
    3.95,                                  !- Rated COP
    3.776,                                 !- Rated Air Flow Rate {m3/s}
    ,                                      !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,                    !- Air Inlet Node Name
    DXCoilAirOutletNode,                   !- Air Outlet Node Name
    Carrier Centurion 50PG24 CapFT,        !- Total Cooling Capacity Function of Temperature Curve Name
    Carrier Centurion 50PG24 CapFFF,       !- Total Cooling Capacity Function of Flow Fraction Curve Name
    Carrier Centurion 50PG24 EIRFT,        !- Energy Input Ratio Function of Temperature Curve Name
    Carrier Centurion 50PG24 EIRFFF,       !- Energy Input Ratio Function of Flow Fraction Curve Name
    Carrier Centurion 50PG24 PLFFPLR;      !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));

  record  Carrier_Comfort_50ES060 =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe=1800,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -17500.95,
      COP_nominal =           3.9,
      SHR_nominal =           0.78,
      m_flow_nominal =        1.2*0.944),
      perCur =
      Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {1.6380187,-0.0747347,0.0029747,0.0015201,-0.0000519,-0.0004509},
      capFunFF =             {0.8185792,0.2831771,-0.1017563},
      EIRFunT =              {-0.2209648,0.1033303,-0.0030061,-0.0070657,0.0006322,-0.0002496},
      EIRFunFF =             {1.0380778,-0.2013868,0.1633090},
      TConInMin =            273.15 + 23.89,
      TConInMax =            273.15 + 51.67,
      TEvaInMin =            273.15 + 13.89,
      TEvaInMax =            273.15 + 22.22,
      ffMin =                0.875,
      ffMax =                1.125))})
"Carrier Comfort 50ES060"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>Performance data for DX single speed cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    Carrier Comfort 50ES060,              !- Name
    CoolingCoilAvailSched,                !- Availability Schedule Name
    17500.95,                             !- Rated Total Cooling Capacity {W}
    0.78,                                 !- Rated Sensible Heat Ratio
    3.9,                                  !- Rated COP
    0.944,                                !- Rated Air Flow Rate {m3/s}
    ,                                     !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,                   !- Air Inlet Node Name
    DXCoilAirOutletNode,                  !- Air Outlet Node Name
    Carrier Comfort 50ES060 CapFT,        !- Total Cooling Capacity Function of Temperature Curve Name
    Carrier Comfort 50ES060 CapFFF,       !- Total Cooling Capacity Function of Flow Fraction Curve Name
    Carrier Comfort 50ES060 EIRFT,        !- Energy Input Ratio Function of Temperature Curve Name
    Carrier Comfort 50ES060 EIRFFF,       !- Energy Input Ratio Function of Flow Fraction Curve Name
    Carrier Comfort 50ES060 PLFFPLR;      !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));

  record  Carrier_Weathermaster_50HJ006 =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe=1800,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -18687,
      COP_nominal =           3.9,
      SHR_nominal =           0.73,
      m_flow_nominal =        1.2*0.944),
      perCur =
      Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {0.3116765,0.0622847,-0.0008633,-0.0066556,-0.0000462,0.0001349},
      capFunFF =             {0.6583072,0.5294956,-0.1869478},
      EIRFunT =              {1.0505234,-0.0653230,0.0021068,0.0235557,0.0004542,-0.0014092},
      EIRFunFF =             {1.3293472,-0.5218591,0.1918220},
      TConInMin =            273.15 + 23.89,
      TConInMax =            273.15 + 51.67,
      TEvaInMin =            273.15 + 16.67,
      TEvaInMax =            273.15 + 22.22,
      ffMin =                0.75,
      ffMax =                1.25))})
"Carrier Weathermaster 50HJ006"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>Performance data for DX single speed cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    Carrier Weathermaster 50HJ006,              !- Name
    CoolingCoilAvailSched,                      !- Availability Schedule Name
    18687,                                      !- Rated Total Cooling Capacity {W}
    0.73,                                       !- Rated Sensible Heat Ratio
    3.9,                                        !- Rated COP
    0.944,                                      !- Rated Air Flow Rate {m3/s}
    ,                                           !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,                         !- Air Inlet Node Name
    DXCoilAirOutletNode,                        !- Air Outlet Node Name
    Carrier Weathermaster 50HJ006 CapFT,        !- Total Cooling Capacity Function of Temperature Curve Name
    Carrier Weathermaster 50HJ006 CapFFF,       !- Total Cooling Capacity Function of Flow Fraction Curve Name
    Carrier Weathermaster 50HJ006 EIRFT,        !- Energy Input Ratio Function of Temperature Curve Name
    Carrier Weathermaster 50HJ006 EIRFFF,       !- Energy Input Ratio Function of Flow Fraction Curve Name
    Carrier Weathermaster 50HJ006 PLFFPLR;      !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));

  record  Carrier_Weathermaster_50HJ012 =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe=1800,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -36846.82,
      COP_nominal =           3.71,
      SHR_nominal =           0.73,
      m_flow_nominal =        1.2*1.888),
      perCur =
      Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {0.5878544,0.0247382,0.0001631,-0.0034960,-0.0000889,0.0001450},
      capFunFF =             {0.7232943,0.4292712,-0.1525863},
      EIRFunT =              {0.6445678,-0.0198276,0.0010284,0.0222812,0.0004996,-0.0015296},
      EIRFunFF =             {1.2158796,-0.3411366,0.1251095},
      TConInMin =            273.15 + 23.89,
      TConInMax =            273.15 + 51.67,
      TEvaInMin =            273.15 + 16.67,
      TEvaInMax =            273.15 + 22.22,
      ffMin =                0.75,
      ffMax =                1.25))})
"Carrier Weathermaster 50HJ012"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>Performance data for DX single speed cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    Carrier Weathermaster 50HJ012,               !- Name
    CoolingCoilAvailSched,                       !- Availability Schedule Name
    36846.82,                                    !- Rated Total Cooling Capacity {W}
    0.73,                                        !- Rated Sensible Heat Ratio
    3.71,                                        !- Rated COP
    1.888,                                       !- Rated Air Flow Rate {m3/s}
    ,                                            !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,                          !- Air Inlet Node Name
    DXCoilAirOutletNode,                         !- Air Outlet Node Name
    Carrier Weathermaster 50HJ012 CapFT,         !- Total Cooling Capacity Function of Temperature Curve Name
    Carrier Weathermaster 50HJ012 CapFFF,        !- Total Cooling Capacity Function of Flow Fraction Curve Name
    Carrier Weathermaster 50HJ012 EIRFT,         !- Energy Input Ratio Function of Temperature Curve Name
    Carrier Weathermaster 50HJ012 EIRFFF,        !- Energy Input Ratio Function of Flow Fraction Curve Name
    Carrier Weathermaster 50HJ012 PLFFPLR;       !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));

  record  Carrier_Weathermaster_50HJ024 =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe=1800,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -73517.9,
      COP_nominal =           3.73,
      SHR_nominal =           0.76,
      m_flow_nominal =        1.2*3.776),
      perCur =
      Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {1.1345120,-0.0239764,0.0012836,0.0023642,-0.0000802,-0.0001980},
      capFunFF =             {0.7578828,0.3524189,-0.1092772},
      EIRFunT =              {0.3439210,0.0215041,-0.0006539,0.0073217,0.0003160,-0.0002297},
      EIRFunFF =             {1.2167653,-0.3411749,0.1233570},
      TConInMin =            273.15 + 15.56,
      TConInMax =            273.15 + 51.67,
      TEvaInMin =            273.15 + 12.22,
      TEvaInMax =            273.15 + 26.67,
      ffMin =                0.75,
      ffMax =                1.25))})
"Carrier Weathermaster 50HJ024"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>Performance data for DX single speed cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    Carrier Weathermaster 50HJ024,              !- Name
    CoolingCoilAvailSched,                      !- Availability Schedule Name
    73517.9,                                    !- Rated Total Cooling Capacity {W}
    0.76,                                       !- Rated Sensible Heat Ratio
    3.73,                                       !- Rated COP
    3.776,                                      !- Rated Air Flow Rate {m3/s}
    ,                                           !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,                         !- Air Inlet Node Name
    DXCoilAirOutletNode,                        !- Air Outlet Node Name
    Carrier Weathermaster 50HJ024 CapFT,        !- Total Cooling Capacity Function of Temperature Curve Name
    Carrier Weathermaster 50HJ024 CapFFF,       !- Total Cooling Capacity Function of Flow Fraction Curve Name
    Carrier Weathermaster 50HJ024 EIRFT,        !- Energy Input Ratio Function of Temperature Curve Name
    Carrier Weathermaster 50HJ024 EIRFFF,       !- Energy Input Ratio Function of Flow Fraction Curve Name
    Carrier Weathermaster 50HJ024 PLFFPLR;      !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));

  record  Goodman_CPC060 =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe=1800,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -17427.55,
      COP_nominal =           3.95,
      SHR_nominal =           0.72,
      m_flow_nominal =        1.2*0.944),
      perCur =
      Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {1.3045870,-0.0618386,0.0024674,0.0081572,-0.0001826,-0.0001610},
      capFunFF =             {-0.9361345,3.4420168,-1.5058824},
      EIRFunT =              {0.1618862,0.0531671,-0.0015621,0.0077612,0.0001864,-0.0001388},
      EIRFunFF =             {2.2905751,-2.2915498,1.0009747},
      TConInMin =            273.15 + 18.33,
      TConInMax =            273.15 + 46.11,
      TEvaInMin =            273.15 + 15,
      TEvaInMax =            273.15 + 21.67,
      ffMin =                0.875,
      ffMax =                1.125))})
"Goodman CPC060"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>Performance data for DX single speed cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    Goodman CPC060,              !- Name
    CoolingCoilAvailSched,       !- Availability Schedule Name
    17427.55,                    !- Rated Total Cooling Capacity {W}
    0.72,                        !- Rated Sensible Heat Ratio
    3.95,                        !- Rated COP
    0.944,                       !- Rated Air Flow Rate {m3/s}
    ,                            !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,          !- Air Inlet Node Name
    DXCoilAirOutletNode,         !- Air Outlet Node Name
    Goodman CPC060 CapFT,        !- Total Cooling Capacity Function of Temperature Curve Name
    Goodman CPC060 CapFFF,       !- Total Cooling Capacity Function of Flow Fraction Curve Name
    Goodman CPC060 EIRFT,        !- Energy Input Ratio Function of Temperature Curve Name
    Goodman CPC060 EIRFFF,       !- Energy Input Ratio Function of Flow Fraction Curve Name
    Goodman CPC060 PLFFPLR;      !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));

  record  York_Affinity_DNP060 =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe=1800,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -17200,
      COP_nominal =           3.88,
      SHR_nominal =           0.71,
      m_flow_nominal =        1.2*0.8496),
      perCur =
      Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {0.9829911,-0.0197231,0.0016341,0.0058106,-0.0000309,-0.0005776},
      capFunFF =             {0.9268752,0.0902018,-0.0175149},
      EIRFunT =              {0.2246908,0.0390385,-0.0010832,0.0080036,0.0003449,-0.0004327},
      EIRFunFF =             {2.0004106,-2.4070885,1.3922562},
      TConInMin =            273.15 + 23.89,
      TConInMax =            273.15 + 51.67,
      TEvaInMin =            273.15 + 13.89,
      TEvaInMax =            273.15 + 25,
      ffMin =                0.833,
      ffMax =                1.167))})
"York Affinity DNP060"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>Performance data for DX single speed cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    York Affinity DNP060,               !- Name
    CoolingCoilAvailSched,              !- Availability Schedule Name
    17200,                              !- Rated Total Cooling Capacity {W}
    0.71,                               !- Rated Sensible Heat Ratio
    3.88,                               !- Rated COP
    0.8496,                             !- Rated Air Flow Rate {m3/s}
    ,                                   !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,                 !- Air Inlet Node Name
    DXCoilAirOutletNode,                !- Air Outlet Node Name
    York Affinity DNP060 CapFT,         !- Total Cooling Capacity Function of Temperature Curve Name
    York Affinity DNP060 CapFFF,        !- Total Cooling Capacity Function of Flow Fraction Curve Name
    York Affinity DNP060 EIRFT,         !- Energy Input Ratio Function of Temperature Curve Name
    York Affinity DNP060 EIRFFF,        !- Energy Input Ratio Function of Flow Fraction Curve Name
    York Affinity DNP060 PLFFPLR;       !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));

  record  York_Affinity_DNZ060 =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe=1800,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -17395.3,
      COP_nominal =           4.24,
      SHR_nominal =           0.68,
      m_flow_nominal =        1.2*0.826),
      perCur =
      Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {1.2343140,-0.0398816,0.0019354,0.0062114,-0.0001247,-0.0003619},
      capFunFF =             {1.2527302,-0.7182445,0.4623738},
      EIRFunT =              {-0.1272387,0.0848124,-0.0021062,-0.0085792,0.0007783,-0.0005585},
      EIRFunFF =             {0.6529892,0.8193151,-0.4617716},
      TConInMin =            273.15 + 23.89,
      TConInMax =            273.15 + 51.67,
      TEvaInMin =            273.15 + 13.89,
      TEvaInMax =            273.15 + 25,
      ffMin =                0.714,
      ffMax =                1.2))})
"York Affinity DNZ060"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>Performance data for DX single speed cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    York Affinity DNZ060,               !- Name
    CoolingCoilAvailSched,              !- Availability Schedule Name
    17395.3,                            !- Rated Total Cooling Capacity {W}
    0.68,                               !- Rated Sensible Heat Ratio
    4.24,                               !- Rated COP
    0.826,                              !- Rated Air Flow Rate {m3/s}
    ,                                   !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,                 !- Air Inlet Node Name
    DXCoilAirOutletNode,                !- Air Outlet Node Name
    York Affinity DNZ060 CapFT,         !- Total Cooling Capacity Function of Temperature Curve Name
    York Affinity DNZ060 CapFFF,        !- Total Cooling Capacity Function of Flow Fraction Curve Name
    York Affinity DNZ060 EIRFT,         !- Energy Input Ratio Function of Temperature Curve Name
    York Affinity DNZ060 EIRFFF,        !- Energy Input Ratio Function of Flow Fraction Curve Name
    York Affinity DNZ060 PLFFPLR;       !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));

  record  York_Lattitude_SJ060 =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe=1800,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -17427.55,
      COP_nominal =           4.25,
      SHR_nominal =           0.70,
      m_flow_nominal =        1.2*0.944),
      perCur =
      Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {0.8277321,-0.0496772,0.0021600,0.0350767,-0.0004860,-0.0004331},
      capFunFF =             {1.3022329,-0.7346939,0.4379352},
      EIRFunT =              {0.1643011,0.0818978,-0.0021640,-0.0183702,0.0007849,-0.0003855},
      EIRFunFF =             {0.7757255,0.5279901,-0.3030465},
      TConInMin =            273.15 + 23.89,
      TConInMax =            273.15 + 51.67,
      TEvaInMin =            273.15 + 13.89,
      TEvaInMax =            273.15 + 22.22,
      ffMin =                0.75,
      ffMax =                1.25))})
"York Lattitude SJ060"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>Performance data for DX single speed cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    York Lattitude SJ060,              !- Name
    CoolingCoilAvailSched,             !- Availability Schedule Name
    17427.55,                          !- Rated Total Cooling Capacity {W}
    0.70,                              !- Rated Sensible Heat Ratio
    4.25,                              !- Rated COP
    0.944,                             !- Rated Air Flow Rate {m3/s}
    ,                                  !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,                !- Air Inlet Node Name
    DXCoilAirOutletNode,               !- Air Outlet Node Name
    York Lattitude SJ060 CapFT,        !- Total Cooling Capacity Function of Temperature Curve Name
    York Lattitude SJ060 CapFFF,       !- Total Cooling Capacity Function of Flow Fraction Curve Name
    York Lattitude SJ060 EIRFT,        !- Energy Input Ratio Function of Temperature Curve Name
    York Lattitude SJ060 EIRFFF,       !- Energy Input Ratio Function of Flow Fraction Curve Name
    York Lattitude SJ060 PLFFPLR;      !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));

  record  York_Lattitude_NM060 =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe=1800,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -17100,
      COP_nominal =           3.85,
      SHR_nominal =           0.70,
      m_flow_nominal =        1.2*0.8024),
      perCur =
      Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {1.1028912,-0.0119627,0.0014640,-0.0041312,-0.0000388,-0.0003520},
      capFunFF =             {0.7060647,0.3967112,-0.1059134},
      EIRFunT =              {0.0281200,0.0456536,-0.0006039,0.0145030,0.0006477,-0.0014811},
      EIRFunFF =             {0.4662994,0.2484568,-0.0381443},
      TConInMin =            273.15 + 23.89,
      TConInMax =            273.15 + 51.67,
      TEvaInMin =            273.15 + 13.89,
      TEvaInMax =            273.15 + 25,
      ffMin =                0.824,
      ffMax =                1.47))})
"York Lattitude NM060"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>Performance data for DX single speed cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    York Lattitude NM060,               !- Name
    CoolingCoilAvailSched,              !- Availability Schedule Name
    17100,                              !- Rated Total Cooling Capacity {W}
    0.70,                               !- Rated Sensible Heat Ratio
    3.85,                               !- Rated COP
    0.8024,                             !- Rated Air Flow Rate {m3/s}
    ,                                   !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,                 !- Air Inlet Node Name
    DXCoilAirOutletNode,                !- Air Outlet Node Name
    York Lattitude NM060 CapFT,         !- Total Cooling Capacity Function of Temperature Curve Name
    York Lattitude NM060 CapFFF,        !- Total Cooling Capacity Function of Flow Fraction Curve Name
    York Lattitude NM060 EIRFT,         !- Energy Input Ratio Function of Temperature Curve Name
    York Lattitude NM060 EIRFFF,        !- Energy Input Ratio Function of Flow Fraction Curve Name
    York Lattitude NM060 PLFFPLR;       !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));

  record  York_Predator_ZF120 =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe=1800,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -36905.4,
      COP_nominal =           4.06,
      SHR_nominal =           0.734,
      m_flow_nominal =        1.2*1.888),
      perCur =
      Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {1.2083456,-0.0287633,0.0022322,0.0019731,-0.0000541,-0.0007392},
      capFunFF =             {0.6735828,0.4697959,-0.1469388},
      EIRFunT =              {0.4822073,0.0401530,-0.0015820,-0.0116025,0.0006758,-0.0001198},
      EIRFunFF =             {1.3074459,-0.4421330,0.1377204},
      TConInMin =            273.15 + 23.89,
      TConInMax =            273.15 + 51.67,
      TEvaInMin =            273.15 + 13.89,
      TEvaInMax =            273.15 + 25,
      ffMin =                0.625,
      ffMax =                1.25))})
"York Predator ZF120"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>Performance data for DX single speed cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    York Predator ZF120,               !- Name
    CoolingCoilAvailSched,             !- Availability Schedule Name
    36905.4,                           !- Rated Total Cooling Capacity {W}
    0.734,                             !- Rated Sensible Heat Ratio
    4.06,                              !- Rated COP
    1.888,                             !- Rated Air Flow Rate {m3/s}
    ,                                  !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,                !- Air Inlet Node Name
    DXCoilAirOutletNode,               !- Air Outlet Node Name
    York Predator ZF120 CapFT,         !- Total Cooling Capacity Function of Temperature Curve Name
    York Predator ZF120 CapFFF,        !- Total Cooling Capacity Function of Flow Fraction Curve Name
    York Predator ZF120 EIRFT,         !- Energy Input Ratio Function of Temperature Curve Name
    York Predator ZF120 EIRFFF,        !- Energy Input Ratio Function of Flow Fraction Curve Name
    York Predator ZF120 PLFFPLR;       !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));

  record  York_Sunline_ZR060 =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe=1800,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -18687,
      COP_nominal =           3.98,
      SHR_nominal =           0.685,
      m_flow_nominal =        1.2*0.944),
      perCur =
      Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {1.1491510,-0.0161007,0.0015936,-0.0027657,-0.0000236,-0.0004692},
      capFunFF =             {0.3148231,1.0463502,-0.3708016},
      EIRFunT =              {0.1210878,0.0560928,-0.0012307,0.0092825,0.0005999,-0.0010492},
      EIRFunFF =             {1.9711221,-1.6315991,0.6688369},
      TConInMin =            273.15 + 23.89,
      TConInMax =            273.15 + 51.67,
      TEvaInMin =            273.15 + 13.89,
      TEvaInMax =            273.15 + 25,
      ffMin =                0.625,
      ffMax =                1.25))})
"York Sunline ZR060"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>Performance data for DX single speed cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    York Sunline ZR060,              !- Name
    CoolingCoilAvailSched,           !- Availability Schedule Name
    18687,                           !- Rated Total Cooling Capacity {W}
    0.685,                           !- Rated Sensible Heat Ratio
    3.98,                            !- Rated COP
    0.944,                           !- Rated Air Flow Rate {m3/s}
    ,                                !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,              !- Air Inlet Node Name
    DXCoilAirOutletNode,             !- Air Outlet Node Name
    York Sunline ZR060 CapFT,        !- Total Cooling Capacity Function of Temperature Curve Name
    York Sunline ZR060 CapFFF,       !- Total Cooling Capacity Function of Flow Fraction Curve Name
    York Sunline ZR060 EIRFT,        !- Energy Input Ratio Function of Temperature Curve Name
    York Sunline ZR060 EIRFFF,       !- Energy Input Ratio Function of Flow Fraction Curve Name
    York Sunline ZR060 PLFFPLR;      !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));

  record  York_Sunline_DR060 =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe=1800,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -17398.26,
      COP_nominal =           4.05,
      SHR_nominal =           0.69,
      m_flow_nominal =        1.2*0.944),
      perCur =
      Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {1.4767927,-0.0614116,0.0027182,-0.0010838,-0.0000353,-0.0003531},
      capFunFF =             {0.9156325,0.0076960,0.0769601},
      EIRFunT =              {-0.2918107,0.0950527,-0.0026508,0.0070978,0.0005090,-0.0006143},
      EIRFunFF =             {0.9336732,0.2228647,-0.1628839},
      TConInMin =            273.15 + 23.89,
      TConInMax =            273.15 + 51.67,
      TEvaInMin =            273.15 + 13.89,
      TEvaInMax =            273.15 + 22.22,
      ffMin =                0.75,
      ffMax =                1.25))})
"York Sunline DR060"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>Performance data for DX single speed cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    York Sunline DR060,               !- Name
    CoolingCoilAvailSched,            !- Availability Schedule Name
    17398.26,                         !- Rated Total Cooling Capacity {W}
    0.69,                             !- Rated Sensible Heat Ratio
    4.05,                             !- Rated COP
    0.944,                            !- Rated Air Flow Rate {m3/s}
    ,                                 !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,               !- Air Inlet Node Name
    DXCoilAirOutletNode,              !- Air Outlet Node Name
    York Sunline DR060 CapFT,         !- Total Cooling Capacity Function of Temperature Curve Name
    York Sunline DR060 CapFFF,        !- Total Cooling Capacity Function of Flow Fraction Curve Name
    York Sunline DR060 EIRFT,         !- Energy Input Ratio Function of Temperature Curve Name
    York Sunline DR060 EIRFFF,        !- Energy Input Ratio Function of Flow Fraction Curve Name
    York Sunline DR060 PLFFPLR;       !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));

  record  York_Sunline_ZF240 =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe=1800,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -81807,
      COP_nominal =           3.59,
      SHR_nominal =           0.70,
      m_flow_nominal =        1.2*3.776),
      perCur =
      Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {1.0477109,-0.0126686,0.0012838,0.0012381,-0.0000551,-0.0003875},
      capFunFF =             {0.6042146,0.6557209,-0.2667894},
      EIRFunT =              {0.4544209,0.0213827,-0.0007051,0.0028662,0.0004214,-0.0003177},
      EIRFunFF =             {1.4410769,-0.7566253,0.3239453},
      TConInMin =            273.15 + 23.89,
      TConInMax =            273.15 + 51.67,
      TEvaInMin =            273.15 + 13.89,
      TEvaInMax =            273.15 + 25,
      ffMin =                0.625,
      ffMax =                1.25))})
"York Sunline ZF240"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>Performance data for DX single speed cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    York Sunline ZF240,               !- Name
    CoolingCoilAvailSched,            !- Availability Schedule Name
    81807,                            !- Rated Total Cooling Capacity {W}
    0.70,                             !- Rated Sensible Heat Ratio
    3.59,                             !- Rated COP
    3.776,                            !- Rated Air Flow Rate {m3/s}
    ,                                 !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,               !- Air Inlet Node Name
    DXCoilAirOutletNode,              !- Air Outlet Node Name
    York Sunline ZF240 CapFT,         !- Total Cooling Capacity Function of Temperature Curve Name
    York Sunline ZF240 CapFFF,        !- Total Cooling Capacity Function of Flow Fraction Curve Name
    York Sunline ZF240 EIRFT,         !- Energy Input Ratio Function of Temperature Curve Name
    York Sunline ZF240 EIRFFF,        !- Energy Input Ratio Function of Flow Fraction Curve Name
    York Sunline ZF240 PLFFPLR;       !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));

  record  York_Sunline_DJ240 =
    Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed.Generic(sta = {
     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(spe=1800,
     nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(
      Q_flow_nominal =        -73518,
      COP_nominal =           4.096,
      SHR_nominal =           0.75,
      m_flow_nominal =        1.2*3.776),
      perCur =
      Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(
      capFunT =              {1.3804089,-0.0801861,0.0033588,0.0118882,-0.0001339,-0.0005357},
      capFunFF =             {0.7894654,0.1996615,0.0111454},
      EIRFunT =              {-0.1635113,0.1222397,-0.0037107,-0.0070372,0.0005052,-0.0002069},
      EIRFunFF =             {1.5272381,-0.9652850,0.4418485},
      TConInMin =            273.15 + 23.89,
      TConInMax =            273.15 + 51.67,
      TEvaInMin =            273.15 + 13.89,
      TEvaInMax =            273.15 + 22.22,
      ffMin =                0.75,
      ffMax =                1.175))})
"York Sunline DJ240"
annotation(
defaultComponentName="datCoi",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>Performance data for DX single speed cooling coil model.
This data corresponds to the following EnergyPlus model:
</p>
<pre>
Coil:Cooling:DX:SingleSpeed,
    York Sunline DJ240,               !- Name
    CoolingCoilAvailSched,            !- Availability Schedule Name
    73518,                            !- Rated Total Cooling Capacity {W}
    0.75,                             !- Rated Sensible Heat Ratio
    4.096,                            !- Rated COP
    3.776,                            !- Rated Air Flow Rate {m3/s}
    ,                                 !- Rated Evaporator Fan Power Per Volume Flow Rate {W/(m3/s)}
    DXCoilAirInletNode,               !- Air Inlet Node Name
    DXCoilAirOutletNode,              !- Air Outlet Node Name
    York Sunline DJ240 CapFT,         !- Total Cooling Capacity Function of Temperature Curve Name
    York Sunline DJ240 CapFFF,        !- Total Cooling Capacity Function of Flow Fraction Curve Name
    York Sunline DJ240 EIRFT,         !- Energy Input Ratio Function of Temperature Curve Name
    York Sunline DJ240 EIRFFF,        !- Energy Input Ratio Function of Flow Fraction Curve Name
    York Sunline DJ240 PLFFPLR;       !- Part Load Fraction Correlation Curve Name
</pre>
</html>"));

end SingleSpeed;
