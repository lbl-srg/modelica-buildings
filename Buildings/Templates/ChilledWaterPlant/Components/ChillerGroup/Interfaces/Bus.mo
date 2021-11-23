within Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.Interfaces;
expandable connector Bus "Generic control bus for chiller group classes"
  extends Modelica.Icons.SignalBus;

  parameter Integer nChi;

  Buildings.Templates.ChilledWaterPlant.Components.Chiller.Interfaces.Bus chi[nChi]
    annotation (HideResult=false);
  Real yValChi[nChi];

  annotation (
  defaultComponentName="busCon",
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
                  extent={{-20,2},{22,-2}},
                  lineColor={255,204,51},
                  lineThickness=0.5)}), Documentation(info="<html>

</html>"));
end Bus;
