within Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed;
record York_Lattitude_NM060 =
  Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.SingleSpeed.Generic (
                                                                  sta = {
   Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
                                                                         spe=1800,
   nomVal = Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
    Q_flow_nominal =        -17100,
    COP_nominal =           3.85,
    SHR_nominal =           0.70,
    m_flow_nominal =        1.2*0.8024),
    perCur=
    Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT =              {1.1028912,-0.0119627,0.0014640,-0.0041312,-0.0000388,-0.0003520},
    capFunFF =             {0.7060647,0.3967112,-0.1059134},
    EIRFunT =              {0.0281200,0.0456536,-0.0006039,0.0145030,0.0006477,-0.0014811},
    EIRFunFF =             {0.4662994,0.2484568,-0.0381443},
    TConInMin =            273.15 + 23.89,
    TConInMax =            273.15 + 51.67,
    TEvaInMin =            273.15 + 13.89,
    TEvaInMax =            273.15 + 25,
    ffMin =                0.824,
    ffMax =                1.47))}) "York Lattitude NM060" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>Performance data for DX single speed air source cooling coil model.
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
