within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.BoreHoles.Interface;
partial model PartialBoreHoleInternalHEX
  extends PartialBoreHoleElement;

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
                              annotation (choicesAllMatching=true);

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port
    "Heat port that connects to filling material" annotation (Placement(
        transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={
            {-10,90},{10,110}})));

  annotation (Diagram(coordinateSystem(extent={{-100,-120},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-120},{100,100}})));
end PartialBoreHoleInternalHEX;
