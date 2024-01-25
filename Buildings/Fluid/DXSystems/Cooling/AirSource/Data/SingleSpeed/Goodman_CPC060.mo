within Buildings.Fluid.DXSystems.Cooling.AirSource.Data.SingleSpeed;
record Goodman_CPC060 =
  Buildings.Fluid.DXSystems.Cooling.AirSource.Data.SingleSpeed.Generic
    (                                                             sta = {
   Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe=1800,
   nomVal = Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -17427.55,
    COP_nominal =           3.95,
    SHR_nominal =           0.72,
    m_flow_nominal =        1.2*0.944),
    perCur=
    Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {1.3045870,-0.0618386,0.0024674,0.0081572,-0.0001826,-0.0001610},
    capFunFF =             {-0.9361345,3.4420168,-1.5058824},
    EIRFunT =              {0.1618862,0.0531671,-0.0015621,0.0077612,0.0001864,-0.0001388},
    EIRFunFF =             {2.2905751,-2.2915498,1.0009747},
    TConInMin =            273.15 + 18.33,
    TConInMax =            273.15 + 46.11,
    TEvaInMin =            273.15 + 15,
    TEvaInMax =            273.15 + 21.67,
    ffMin =                0.875,
    ffMax =                1.125))}) "Goodman CPC060" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>Performance data for DX single speed air source cooling coil model.
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
