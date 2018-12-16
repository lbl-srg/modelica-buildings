within Buildings.Fluid.Actuators.BaseClasses;
block LinearizeValveEqual
  "Linearizing block for equal percentage valve with optional fixed flow resistance"
  extends Modelica.Blocks.Interfaces.SISO;

  parameter Real dpFixed_nominal;
  parameter Real dp_nominal_pos;
  parameter Real m_flow_nominal_pos;
  parameter Real Kv_SI;
  parameter Real kFixed;
  parameter Real R;
  parameter Real delta0;
  parameter Real l;
  parameter String fitMod;
  parameter Real b1;
  parameter Real b2;

equation
  y = noEvent(if (u < Modelica.Constants.eps or u > 1-Modelica.Constants.eps) then u else
      if (dpFixed_nominal > Modelica.Constants.eps) then Buildings.Fluid.Actuators.BaseClasses.equalPercentageInv(
        sqrt(1 / (dp_nominal_pos/
        (Buildings.Fluid.Actuators.BaseClasses.characteristicFitHX(x=u, fitMod=fitMod, b1=b1, b2=b2)*m_flow_nominal_pos^2)
        - 1 / kFixed^2)) / Kv_SI,
      R, l, delta0) else Buildings.Fluid.Actuators.BaseClasses.equalPercentageInv(
      sqrt(Buildings.Fluid.Actuators.BaseClasses.characteristicFitHX(x=u, fitMod=fitMod, b1=b1, b2=b2)), R, l, delta0));

end LinearizeValveEqual;
