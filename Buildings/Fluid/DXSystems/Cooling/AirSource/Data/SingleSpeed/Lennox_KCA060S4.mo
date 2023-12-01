within Buildings.Fluid.DXSystems.Cooling.AirSource.Data.SingleSpeed;
record Lennox_KCA060S4 =
  Buildings.Fluid.DXSystems.Cooling.AirSource.Data.SingleSpeed.Generic (
      sta={
        Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800,
        nomVal=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-18101.22,
          COP_nominal=4.07,
          SHR_nominal=0.72,
          m_flow_nominal=1.2*0.944),
        perCur=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
          capFunT={0.9600147,-0.0106038,0.0013516,0.0039357,-0.0000568,-0.0004915},
          capFunFF={0.7491909,0.3721683,-0.1213592},
          EIRFunT={0.2484029,0.0610633,-0.0017081,-0.0102658,0.0007028,-0.0004237},
          EIRFunFF={1.2094575,-0.3165036,0.1070461},
          TConInMin=273.15 + 18.33,
          TConInMax=273.15 + 35,
          TEvaInMin=273.15 + 17.22,
          TEvaInMax=273.15 + 29.44,
          ffMin=0.8,
          ffMax=1.2))}) "Lennox KCA060S4" annotation (
  defaultComponentName="datCoi",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>Performance data for DX single speed air source cooling coil model.
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
