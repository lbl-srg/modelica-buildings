within Buildings.Templates.AHUs.Coils.HeatExchangers.Data;
record DXVariableSpeed
  extends Interfaces.Data.Coil;

  parameter Real minSpeRat(min=0,max=1)=0.1 "Minimum speed ratio";
  parameter Real speRatDeaBan=0.05 "Deadband for minimum speed ratio";
  replaceable parameter Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil datCoi(
    nSta=4,
    sta={Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.Stage(
      spe=900/60,
      nomVal=Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
        Q_flow_nominal=-12000,
        COP_nominal=3,
        SHR_nominal=0.8,
        m_flow_nominal=0.9),
      perCur=Fluid.HeatExchangers.DXCoils.AirCooled.Examples.PerformanceCurves.Curve_I()),
      Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.Stage(
      spe=1200/60,
      nomVal=Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
        Q_flow_nominal=-18000,
        COP_nominal=3,
        SHR_nominal=0.8,
        m_flow_nominal=1.2),
      perCur=Fluid.HeatExchangers.DXCoils.AirCooled.Examples.PerformanceCurves.Curve_I()),
      Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.Stage(
      spe=1800/60,
      nomVal=Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
        Q_flow_nominal=-21000,
        COP_nominal=3,
        SHR_nominal=0.8,
        m_flow_nominal=1.5),
      perCur=Fluid.HeatExchangers.DXCoils.AirCooled.Examples.PerformanceCurves.Curve_II()),
      Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.Stage(
      spe=2400/60,
      nomVal=Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
        Q_flow_nominal=-30000,
        COP_nominal=3,
        SHR_nominal=0.8,
        m_flow_nominal=1.8),
      perCur=Fluid.HeatExchangers.DXCoils.AirCooled.Examples.PerformanceCurves.Curve_III())})
    constrainedby Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil
    annotation(choicesAllMatching=true);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end DXVariableSpeed;
