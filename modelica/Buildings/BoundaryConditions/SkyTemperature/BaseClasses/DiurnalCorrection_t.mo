within Buildings.BoundaryConditions.SkyTemperature.BaseClasses;
block DiurnalCorrection_t
  "Diurnal correction for difference in sky emissivities at day and night"

  import Buildings;
  extends Modelica.Blocks.Interfaces.BlockIcon;

public
  Modelica.Blocks.Interfaces.RealInput cloTim(quantity="Time", unit="s")
    "Clock time"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y "Diurnal correction"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  Buildings.BoundaryConditions.SkyTemperature.BaseClasses.DiurnalCorrection
    diuCor annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarTime solTim
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.LocalTime locTim
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.EquationOfTime eqnTim
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

equation
  connect(solTim.solTim, diuCor.solTim) annotation (Line(
      points={{21,6.10623e-16},{25.25,6.10623e-16},{25.25,1.27676e-15},{29.5,
          1.27676e-15},{29.5,6.66134e-16},{38,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eqnTim.eqnTim, solTim.equTim) annotation (Line(
      points={{-19,30},{-10,30},{-10,6},{-2,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eqnTim.nDay,cloTim)  annotation (Line(
      points={{-42,30},{-60,30},{-60,1.11022e-15},{-120,1.11022e-15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(locTim.cloTim,cloTim)  annotation (Line(
      points={{-42,-30},{-60,-30},{-60,1.11022e-15},{-120,1.11022e-15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solTim.locTim, locTim.locTim) annotation (Line(
      points={{-2,-5.4},{-2,-4},{-10,-4},{-10,-30},{-19,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(diuCor.diuCor, y) annotation (Line(
      points={{61,6.10623e-16},{73.25,6.10623e-16},{73.25,1.16573e-15},{85.5,
          1.16573e-15},{85.5,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    defaultComponentName="diuCor_t",
    Documentation(info="<HTML>
<p>
This component computes the diurnal correction by usng time as input.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
May 24, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255})}));
end DiurnalCorrection_t;
