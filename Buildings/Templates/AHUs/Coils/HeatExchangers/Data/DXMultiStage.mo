within Buildings.Templates.AHUs.Coils.HeatExchangers.Data;
record DXMultiStage
  extends Interfaces.Data.Coil;

  replaceable parameter
    Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil datCoi
    constrainedby Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil
    annotation(choicesAllMatching=true);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end DXMultiStage;
