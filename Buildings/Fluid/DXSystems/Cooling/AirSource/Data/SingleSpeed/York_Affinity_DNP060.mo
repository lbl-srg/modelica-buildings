within Buildings.Fluid.DXSystems.Cooling.AirSource.Data.SingleSpeed;
record York_Affinity_DNP060 =
  Buildings.Fluid.DXSystems.Cooling.AirSource.Data.SingleSpeed.Generic
    (                                                             sta = {
   Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe=1800,
   nomVal = Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -17200,
    COP_nominal =           3.88,
    SHR_nominal =           0.71,
    m_flow_nominal =        1.2*0.8496),
    perCur=
    Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {0.9829911,-0.0197231,0.0016341,0.0058106,-0.0000309,-0.0005776},
    capFunFF =             {0.9268752,0.0902018,-0.0175149},
    EIRFunT =              {0.2246908,0.0390385,-0.0010832,0.0080036,0.0003449,-0.0004327},
    EIRFunFF =             {2.0004106,-2.4070885,1.3922562},
    TConInMin =            273.15 + 23.89,
    TConInMax =            273.15 + 51.67,
    TEvaInMin =            273.15 + 13.89,
    TEvaInMax =            273.15 + 25,
    ffMin =                0.833,
    ffMax =                1.167))}) "York Affinity DNP060" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>Performance data for DX single speed air source cooling coil model.
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
