within Buildings.Media.Examples;
model SteamProperties
  "Model that tests the implementation of the steam properties"
  extends Modelica.Icons.Example;
  extends Buildings.Media.Examples.BaseClasses.PartialProperties(
    redeclare package Medium = Buildings.Media.Steam,
    TMin=273.15 + 100,
    TMax=273.15 + 700,
    p=100000,
    errAbs=0.01);

  Medium.ThermodynamicState state_phX "Medium state";
  Medium.ThermodynamicState state_psX "Medium state";

  Modelica.Media.Interfaces.Types.DerDensityByEnthalpy ddhp
    "Density derivative w.r.t. enthalpy";
  Modelica.Media.Interfaces.Types.DerDensityByPressure ddph
    "Density derivative w.r.t. pressure";

equation

   // Check setting the states
    state_pTX = Medium.setState_pTX(p=p, T=T);
    state_phX = Medium.setState_phX(p=p, h=h);
    state_psX = Medium.setState_psX(p=p, s=s);
    checkState(state_pTX, state_phX, errAbs, "state_phX");
    checkState(state_pTX, state_psX, errAbs, "state_psX");

    // Check the implementation of the functions
    ddhp = Medium.density_derh_p(state_pTX);
    ddph = Medium.density_derp_h(state_pTX);

  // Check the implementation of the base properties
  basPro.state.p=p;
  basPro.state.T=T;

   annotation(experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Media/Examples/SteamProperties.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This example checks thermophysical properties of the medium.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 6, 2020, by Kathryn Hinkelman:<br/>
Change medium to ideal steam to eliminate discontinuities.
</li>
<li>
September 12, 2019, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SteamProperties;
