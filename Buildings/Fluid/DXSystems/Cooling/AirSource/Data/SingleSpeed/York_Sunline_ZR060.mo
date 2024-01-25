within Buildings.Fluid.DXSystems.Cooling.AirSource.Data.SingleSpeed;
record York_Sunline_ZR060 =
  Buildings.Fluid.DXSystems.Cooling.AirSource.Data.SingleSpeed.Generic
    (                                                             sta = {
   Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe=1800,
   nomVal = Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -18687,
    COP_nominal =           3.98,
    SHR_nominal =           0.685,
    m_flow_nominal =        1.2*0.944),
    perCur=
    Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {1.1491510,-0.0161007,0.0015936,-0.0027657,-0.0000236,-0.0004692},
    capFunFF =             {0.3148231,1.0463502,-0.3708016},
    EIRFunT =              {0.1210878,0.0560928,-0.0012307,0.0092825,0.0005999,-0.0010492},
    EIRFunFF =             {1.9711221,-1.6315991,0.6688369},
    TConInMin =            273.15 + 23.89,
    TConInMax =            273.15 + 51.67,
    TEvaInMin =            273.15 + 13.89,
    TEvaInMax =            273.15 + 25,
    ffMin =                0.625,
    ffMax =                1.25))}) "York Sunline ZR060" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>Performance data for DX single speed air source cooling coil model.
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
