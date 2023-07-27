within Buildings.ThermalZones.ReducedOrder;
package RC "Package with reduced order thermal zones based on VDI 6007 Part 1"
  extends Modelica.Icons.VariantsPackage;

  package UsersGuide "User's Guide"
    extends Modelica.Icons.Information;


    annotation (Documentation(info="<html>
  <p>
  This package contains
  models for reduced building physics of thermal zones, where we mean by
  reduced order fewer numbers of wall elements and fewer numbers of RC-elements
  per wall (by means of spatial discretization).
  Such a reduction leads to fewer state variables.
  Reduced order models are commonly used when simulating
  multiple buildings, such as for district simulation, or for model predictive control,
  where simulation speed requirements, aggregation of multiple buildings
  and lack of data availability
  justify simpler models. However, this package allows users to
  choose between models with one to four wall elements, and to define the
  number of RC-elements per wall for each wall. The latter can be done by setting
  <i>n<sub>k</sub></i>, which is the length of the vectors for resistances
  <i>R<sub>k</sub></i> and capacities <i>C<sub>k</sub></i>).
  </p>
  <p>
  All models within this package are based on thermal networks and use chains
  of thermal resistances and capacities to reflect heat transfer and heat
  storage. Thermal network models generally focus on one-dimensional heat
  transfer calculations. A geometrically correct representation of all walls of
  a thermal zone is thus not possible. To reduce simulation effort, it is
  furthermore reasonable to aggregate walls to representative elements with
  similar thermal behaviour. Which number of wall elements is sufficient depends
  on the thermal properties of the walls and their excitation (e.g. through
  solar radiation), in particular on the excitation frequencies. The same
  applies for the number of RC-elements per wall.
  </p>
  <p>
  For multiple buildings, higher accuracy (through higher discretization) can come
  at the price of significant computational cost. Furthermore, the achieved
  accuracy is not necessarily higher in all cases. For cases in which only
  little input data is available, the increased discretization sometimes only
  leads to a perceived-accuracy based on large uncertainties in data acquisition.
  </p>
  <p>
  The architecture of all models within this package is defined in the German
  Guideline VDI 6007 Part 1 (VDI, 2012). This guideline describes a dynamic
  thermal building models for calculations of indoor air temperatures and
  heating/cooling power.
  </p>
  <h4>Architecture</h4>
  <p>
  Each wall element uses either
  <a href=\"modelica://Buildings.ThermalZones.ReducedOrder.RC.BaseClasses.ExteriorWall\">
  Buildings.ThermalZones.ReducedOrder.RC.BaseClasses.ExteriorWall</a>
  or
  <a href=\"modelica://Buildings.ThermalZones.ReducedOrder.RC.BaseClasses.InteriorWall\">
  Buildings.ThermalZones.ReducedOrder.RC.BaseClasses.InteriorWall</a>
  to describe heat conduction and storage within the wall, depending if the wall
  contributes to heat transfer to the outdoor environment (exterior walls) or can
  be considered as simple heat storage elements (interior walls). The number of
  RC-elements per wall is hereby up to the user. All exterior walls and windows
  provide a heat port to the outside. All wall elements (exterior walls, windows
  and interior walls) are connected via
  <a href=\"Modelica.Thermal.HeatTransfer.Components.Convection\">
  Modelica.Thermal.HeatTransfer.Components.Convection</a>
  to the convective network and the indoor air.
  </p>
  <p>
  Heat transfer through windows and solar radiation transmission are handled
  separately. One major difference in the implementations in this
  package compared to the guideline is an additional element for heat transfer
  through windows, which are lumped with exterior walls in the guideline VDI 6007
  Part 1 (VDI, 2012). The heat transfer element for the windows allows to model
  the windows without any thermal capacity, as windows have negligible thermal
  mass. Hence, it is not necessary to discretize the window element and heat
  conduction is simply handled by a thermal resistance. Merging windows and
  exterior walls leads to a virtual capacity for the windows and results in a
  shifted reaction of the room temperature to environmental impacts
  (Lauster, Bruentjen <i>et al.</i>, 2014).
  However, the user is free to choose whether keeping windows separately
  (<code>AWin</code>) or merging them (<code>AExt=AExterior+AWindows, AWin=0</code>).
   The window areas can be defined separately for solar
  radiation (vector <code>ATransparent</code>) and heat transfer
  (vector <code>AWin</code>). For cases where the windows are kept separately,
  <code>ATransparent</code> and <code>AWin</code> are equal. When merging
  windows and exterior walls,  <code>AWin</code> can be set to zero while
  <code>ATransparent</code> still represents the actual window area for solar
  radiation calculations.
  The transmission of solar radiation through windows is split up into two parts.
  One part is connected to the indoor radiative heat exchange mesh network using
  a
  <a href=\"modelica://Buildings.ThermalZones.ReducedOrder.RC.BaseClasses.ThermSplitter\">
  Buildings.ThermalZones.ReducedOrder.RC.BaseClasses.ThermSplitter</a>,
  while the other part is directly linked to the convective network. The split
  factor <code>ratioWinConRad </code> is a window property and depends on the
  glazing and used materials.
  </p>
  <p>Regarding indoor radiative heat exchange, a couple of design decisions
  simplify modelling as well as the system&apos;s numerics:</p>
  <ul>
  <li>
  <p>
  Instead of using Stefan&apos;s Law for radiation exchange
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  Q = &epsilon; &sigma; (T<sub>1<sup>4</sup></sub> - T<sub>2<sup>4</sup></sub>),
  </p>
  <p>
  the models use a linearized approach
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  Q = h <sub>rad</sub> (T<sub>1</sub> - T<sub>2</sub>),
  </p>
  <p>
  where
  the radiative heat transfer coefficient
  <i>h<sub>rad</sub></i> is often set to
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  h<sub>rad</sub> = 4 &epsilon; &sigma; T<sub>m<sup>3</sup></sub>
  </p>
  <p>
  where <i>T<sub>m</sub></i>
  is a mean constant temperature of the interacting surfaces.
  </p>
  </li>
  <li>
  <p>
  Indoor radiation exchange is modelled using a mesh network, each wall is
  linked via one resistance with each other wall. Alternatively, one could use a
  star network, where each wall is connected via a resistance to a virtual
  radiation node. However, for cases with more than three elements and a linear
  approach, a mesh network cannot be transformed to a star network without
  introducing deviations.
  </p>
  </li>
  <li>
  <p>
  Solar radiation uses a real input, while internal gains utilize two heat ports,
  one for convective and one for radiative gains. Considering solar radiation
  typically requires several models upstream to calculate angle-dependent
  irradiation or solar absorption and reflection by windows.
  We decided to keep these models separate from the thermal
  zone model. Thus, solar radiation is handled as a basic
  <code>RadiantEnergyFluenceRate</code>.
  For internal gains, the user might need
  to distinguish between convective and radiative heat sources.
  </p>
  </li>
  <li>
  <p>
  For an exact consideration, each element participating in radiative heat
  exchange needs to have a temperature and an area. For solar radiation and
  radiative internal gains, it is common to define the heat flow independently of
  temperature and thus of area as well, assuming that the temperature of the
  source is high compared to the wall surface temperatures.
  By using a
  <a href=\"modelica://Buildings.ThermalZones.ReducedOrder.RC.BaseClasses.ThermSplitter\">
  Buildings.ThermalZones.ReducedOrder.RC.BaseClasses.ThermSplitter</a>
  that distributes the heat flow of the source over the walls according to their
  area, we support this simplified approach. For solar radiation through windows,
  the area of exterior walls and windows with the same orientation as the incoming
  radiation is not taken into account for the distribution as such surfaces cannot
  be hit by the particular radiation. This calculation is performed for each
  orientation separately using
  <a href=\"modelica://Buildings.ThermalZones.ReducedOrder.RC.BaseClasses.splitFacVal\">
  Buildings.ThermalZones.ReducedOrder.RC.BaseClasses.splitFacVal</a>.
  </p>
  </li>
  </ul>
  <h4>Modeling of latent heat gains</h4>
  <p>
  All zone models in <a href=\"modelica://Buildings.ThermalZones.ReducedOrder.RC\">
  Buildings.ThermalZones.ReducedOrder.RC</a> have a parameter <code>use_moisture_balance</code>.
  If set to <code>true</code>, the input connector <code>QLat_flow</code> is enabled.
  This input connector can be used to set the latent heat gain of the zone. The model assumes this
  latent heat gain to be at <i>37</i>&deg;C, e.g., near the skin temperature.
  For other latent sources that are near <i>20</i>&deg;C, this assumption of the temperature
  leads to an error of around <i>2</i>%, which in most cases is considerably smaller than
  the uncertainty of <code>QLat_flow</code>.
  </p>
  <h4>Typical use and important parameter</h4>
  <p>
  The models in this package are typically used in combination with models from
  the parent package
  <a href=\"modelica://Buildings.ThermalZones.ReducedOrder\">
  Buildings.ThermalZones.ReducedOrder</a>.
  A typical application is one building out of a large building stock for
  which the heating and cooling power over a year in hourly time steps should be
  calculated and is afterwards aggregated to the building stock&apos;s overall
  heating power (Lauster, Teichmann <i>et al.</i>, 2014; Lauster <i>et al.</i>, 2015).
  </p>
  <p>The important parameters are as follows:</p>
  <p><code>n...</code> defines the length of chain of RC-elements per wall.</p>
  <p><code>R...[n]</code> is the vector of resistances for the wall element. It
  moves from indoor to outdoor.</p>
  <p><code>C...[n]</code> is the vector of capacities for the wall element. It
  moves from indoor to outdoor.</p>
  <p><code>R...Rem</code> is the remaining resistance between <code>C[end]</code>
  and outdoor surface of wall element. This resistance can be used to ensure that
  the sum of all resistances and coefficients of heat transfer is equal to the
  U-Value.
  It represents the part of the wall that cannot be activated and thus does not
  take part at heat storage.
  </p>
  <p>
  The connector <code>IndoorPort...</code> adds an additional heat port to the
  indoor surface
  of the wall element if set to <code>true</code>. It can be used to add heat
  loads directly to a specific surface or to connect components that distribute
  radiation and have a specific surface temperature, e.g. a floor heating.
  </p>
  <h4>Parameter calculation</h4>
  <p>To calculate parameters of all four models, the Python package TEASER <a
  href=\"https://github.com/RWTH-EBC/TEASER\">
  https://github.com/RWTH-EBC/TEASER</a> can be used.
  <h4>References</h4>
  <p>VDI. German Association of Engineers Guideline VDI 6007-1 March 2012.
  Calculation of transient thermal response of rooms and buildings - modelling of
  rooms.</p>
  <p>M. Lauster, A. Bruentjen, H. Leppmann, M. Fuchs, R. Streblow, D. Mueller.
  <a href=\"modelica://Buildings/Resources/Images/ThermalZones/ReducedOrder/RC/UsersGuide/BauSIM2014_208-2_p1192.pdf\">Improving a Low Order Building Model for Urban Scale Applications</a>.
  <i>Proceedings of BauSim 2014: 5th German-Austrian IBPSA Conference</i>,
  p. 511-518, Aachen, Germany. Sep. 22-24, 2014.</p>
  <p>M. Lauster, J. Teichmann, M. Fuchs, R. Streblow, D. Mueller. Low Order
  Thermal Network Models for Dynamic Simulations of Buildings on City District
  Scale. <i>Building and Environment</i>, 73, 223-231, 2014.
  <a href=\"http://dx.doi.org/10.1016/j.buildenv.2013.12.016\">doi:10.1016/j.buildenv.2013.12.016</a></p>
  <p>M. Lauster, M. Fuchs, M. Huber, P. Remmen, R. Streblow, D. Mueller.
  <a href=\"modelica://Buildings/Resources/Images/ThermalZones/ReducedOrder/RC/UsersGuide/p2241.pdf\">Adaptive Thermal Building Models and Methods for Scalable Simulations of Multiple Buildings using Modelica</a>.
  <i>Proceedings of BS2015: 14th Conference of International Building Performance
  Simulation Association</i>, p. 339-346, Hyderabad, India. Dec. 7-9, 2015. </p>
  </html>"));
  end UsersGuide;

annotation (Documentation(info="<html>
<p>This package contains the core of Reduced Order Models (ROM) that dynamically
calculate the thermal behaviour of building mass.</p>
</html>"));
end RC;
