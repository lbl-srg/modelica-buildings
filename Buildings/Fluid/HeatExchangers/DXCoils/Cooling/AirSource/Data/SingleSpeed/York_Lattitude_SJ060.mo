within Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed;
record York_Lattitude_SJ060 =
  Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed.Generic (
                                                                  sta = {
   Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe=1800,
   nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -17427.55,
    COP_nominal =           4.25,
    SHR_nominal =           0.70,
    m_flow_nominal =        1.2*0.944),
    perCur=
    Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {0.8277321,-0.0496772,0.0021600,0.0350767,-0.0004860,-0.0004331},
    capFunFF =             {1.3022329,-0.7346939,0.4379352},
    EIRFunT =              {0.1643011,0.0818978,-0.0021640,-0.0183702,0.0007849,-0.0003855},
    EIRFunFF =             {0.7757255,0.5279901,-0.3030465},
    TConInMin =            273.15 + 23.89,
    TConInMax =            273.15 + 51.67,
    TEvaInMin =            273.15 + 13.89,
    TEvaInMax =            273.15 + 22.22,
    ffMin =                0.75,
    ffMax =                1.25))}) "York Lattitude SJ060" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>Performance data for DX single speed air source cooling coil model.
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
