within Buildings.Fluid.DXSystems.Cooling.AirSource.Data.SingleSpeed;
record York_Affinity_DNZ060 =
  Buildings.Fluid.DXSystems.Cooling.AirSource.Data.SingleSpeed.Generic (
                                                                  sta = {
   Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe=1800,
   nomVal = Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -17395.3,
    COP_nominal =           4.24,
    SHR_nominal =           0.68,
    m_flow_nominal =        1.2*0.826),
    perCur=
    Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {1.2343140,-0.0398816,0.0019354,0.0062114,-0.0001247,-0.0003619},
    capFunFF =             {1.2527302,-0.7182445,0.4623738},
    EIRFunT =              {-0.1272387,0.0848124,-0.0021062,-0.0085792,0.0007783,-0.0005585},
    EIRFunFF =             {0.6529892,0.8193151,-0.4617716},
    TConInMin =            273.15 + 23.89,
    TConInMax =            273.15 + 51.67,
    TEvaInMin =            273.15 + 13.89,
    TEvaInMax =            273.15 + 25,
    ffMin =                0.714,
    ffMax =                1.2))}) "York Affinity DNZ060" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>Performance data for DX single speed air source cooling coil model.
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
