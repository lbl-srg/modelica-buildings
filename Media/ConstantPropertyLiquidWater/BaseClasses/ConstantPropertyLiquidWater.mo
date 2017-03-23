within Buildings.Media.ConstantPropertyLiquidWater.BaseClasses;
package ConstantPropertyLiquidWater
  "Water: Simple liquid water medium (incompressible, constant data)"

  import Cv = Modelica.SIunits.Conversions;
  extends Buildings.Media.Interfaces.PartialSimpleMedium(
    mediumName="SimpleLiquidWater",
    cp_const=4184,
    cv_const=4184,
    d_const=995.586,
    eta_const=1.e-3,
    lambda_const=0.598,
    a_const=1484,
    T_min=Cv.from_degC(-1),
    T_max=Cv.from_degC(130),
    T0=273.15,
    MM_const=0.018015268,
    fluidConstants=Modelica.Media.Water.ConstantPropertyLiquidWater.simpleWaterConstants,
    ThermoStates=Buildings.Media.Interfaces.Choices.IndependentVariables.T);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-90,88},{90,18}},
          lineColor={0,0,0},
          textString="liquid"), Text(
          extent={{-90,-22},{90,-90}},
          lineColor={0,0,0},
          textString="water")}),
                            Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                    graphics),
    Documentation(info="<html>

</html>"));
end ConstantPropertyLiquidWater;
