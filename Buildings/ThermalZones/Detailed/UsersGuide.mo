within Buildings.ThermalZones.Detailed;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

   class MixedAir "Room model with instantaneously mixed air"
    extends Modelica.Icons.Information;
    annotation (preferredView="info", Documentation(info="<html>
<p>The model <a href=\"modelica://Buildings.ThermalZones.Detailed.MixedAir\">
Buildings.ThermalZones.Detailed.MixedAir</a> is
a model of a room with completely mixed air.
The room can have any number of constructions and surfaces that participate in the
heat exchange through convection, conduction, infrared radiation and solar radiation.</p>
<h4>Physical description</h4>
<p>
A description of the model assumptions and the implemention and validation of this room model can be found in
<a href=\"#WetterEtAl2011\">Wetter et al. (2011)</a>.
Note that this paper describes a previous version of the room model.
The equations have not changed. However, what is shown in Figure 2 in the paper has in this version
of the model been integrated directly into what is shown in Figure 1.</p>
<p>
The room models the following physical processes:
</p>
<ol>
<li>
Transient or steady-state heat conduction through opaque surfaces, using
the model
<a href=\"modelica://Buildings.HeatTransfer.Conduction.MultiLayer\">
Buildings.HeatTransfer.Conduction.MultiLayer</a>
</li>
<li>
Heat transfer through glazing system, taking into account
solar radiation, infrared radiation, heat conduction and heat convection.
The solar radiation is modeled using
<a href=\"modelica://Buildings.HeatTransfer.Windows.BaseClasses.WindowRadiation\">
Buildings.HeatTransfer.Windows.BaseClasses.WindowRadiation</a>.
The overall heat transfer is modeled using the model
<a href=\"modelica://Buildings.HeatTransfer.Windows.Window\">
Buildings.HeatTransfer.Windows.Window</a>
for the glass assembly, and the models
<a href=\"modelica://Buildings.HeatTransfer.Windows.ExteriorHeatTransfer\">
Buildings.HeatTransfer.Windows.ExteriorHeatTransfer</a>,
<a href=\"modelica://Buildings.HeatTransfer.Windows.InteriorHeatTransferConvective\">
Buildings.HeatTransfer.Windows.InteriorHeatTransferConvective</a>
and
<a href=\"modelica://Buildings.HeatTransfer.Windows.BaseClasses.ShadeRadiation\">
Buildings.HeatTransfer.Windows.BaseClasses.ShadeRadiation</a>
for the exterior and interior heat transfer.
A window can have both, an overhang and a side fin.
Overhangs and side fins are modeled using
<a href=\"modelica://Buildings.HeatTransfer.Windows.Overhang\">
Buildings.HeatTransfer.Windows.Overhang</a> and
<a href=\"modelica://Buildings.HeatTransfer.Windows.SideFins\">
Buildings.HeatTransfer.Windows.SideFins</a>, respectively.
These models compute the reduction in direct solar irradiation
due to the external shading device.
</li>
<li>
Convective heat transfer between the outside air and outside-facing surfaces using
either a wind-speed, wind-direction and temperature-dependent heat transfer coefficient,
or using a constant heat transfer coefficient, as described in
<a href=\"modelica://Buildings.HeatTransfer.Convection.Exterior\">
Buildings.HeatTransfer.Convection.Exterior</a>.
</li>
<li>
Solar and infrared heat transfer between the room enclosing surfaces,
convective heat transfer between the room enclosing surfaces and the room air,
and temperature, pressure and species balance inside the room volume.
These effects are modeled as follows:
<ol>
<li>
The model
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.MixedAirHeatMassBalance\">
Buildings.ThermalZones.Detailed.BaseClasses.MixedAirHeatMassBalance</a>
is used to compute heat convection between the room air
and the surface of opaque constructions. It is also used to compute the
heat and mass balance of the room air.
This model is a composite model that contains
<a href=\"modelica://Buildings.HeatTransfer.Windows.InteriorHeatTransferConvective\">
Buildings.HeatTransfer.Windows.InteriorHeatTransferConvective</a> to compute the convective
heat balance of the window and a shade, if present.
The convective heat transfer coefficient can be selected to be
either temperature-dependent or constant.
The convective heat transfer is computed using
<a href=\"modelica://Buildings.HeatTransfer.Convection.Interior\">
Buildings.HeatTransfer.Convection.Interior</a>.
The heat and mass balance of the room air is computed using
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a>,
which assumes the room air to be completely mixed.
Depending on the medium model, moisture and species concentrations,
such as CO<sub>2</sub>, can be modeled transiently.
</li>
<li>
The latent heat gain of the room, which is a user-input,
is converted to a moisture source using
the model
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.HeatGain\">
Buildings.ThermalZones.Detailed.BaseClasses.HeatGain</a>.
</li>
<li>
The radiant heat gains in the infrared spectrum are also a user
input. They are distributed to the room enclosing surfaces using
the model
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.InfraredRadiationGainDistribution\">
Buildings.ThermalZones.Detailed.BaseClasses.InfraredRadiationGainDistribution</a>.
</li>
<li>
The infrared radiative heat exchange between the room enclosing
surfaces is modeled in
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.InfraredRadiationExchange\">
Buildings.ThermalZones.Detailed.BaseClasses.InfraredRadiationExchange</a>.
This model takes into account the absorptivity of the surfaces and
the surface area. However, the view factors are assumed to be
proportional to the area of the receiving surface, without taking
into account the location of the surfaces.
</li>
<li>
The solar radiation exchange is modeled in
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.SolarRadiationExchange\">
Buildings.ThermalZones.Detailed.BaseClasses.SolarRadiationExchange</a>.
The assumptions in this model is that all solar radiation
first hits the floor, and is then partially absorbed and partially reflected by the floor.
The reflectance are diffuse, and the reflected radiation is distributed
in proportion to the product of the receiving areas times their
solar absorptivity.
</li>
</ol>
</li>
</ol>
<h4>Model instantiation</h4>
<p>The next paragraphs describe how to instantiate a room model.
To instantiate a room model,
<ol>
<li>
make an instance of the room model in your model,
</li>
<li>
make instances of constructions from the package
<a href=\"modelica://Buildings.HeatTransfer.Data.OpaqueConstructions\">
Buildings.HeatTransfer.Data.OpaqueConstructions</a> to model opaque constructions such as walls, floors,
ceilings and roofs,
</li>
<li>
make an instance of constructions from the package
<a href=\"modelica://Buildings.HeatTransfer.Data.GlazingSystems\">
Buildings.HeatTransfer.Data.GlazingSystems</a> to model glazing systems, and
</li>
<li>
enter the parameters of the room.
</li>
</ol>
<p>
Entering parameters may be easiest in a textual editor.
</p>
<p>
In the here presented example, we assume we made several instances
of data records for the construction material by dragging them from
the package <a href=\"modelica://Buildings.HeatTransfer.Data\">
Buildings.HeatTransfer.Data</a> to create the following list of declarations:
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'Courier New,courier';\">  </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.HeatTransfer.Data.OpaqueConstructions.Insulation100Concrete200</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    matLayExt </span><span style=\" font-family:'Courier New,courier'; color:#006400;\">\"Construction material for exterior walls\"</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">annotation </span><span style=\" font-family:'Courier New,courier';\">(Placement(transformation(extent={{-60,140},{-40,160}})));</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">  </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.HeatTransfer.Data.OpaqueConstructions.Brick120</span><span style=\" font-family:'Courier New,courier';\"> matLayPar </span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier'; color:#006400;\">    \"Construction material for partition walls\"</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">annotation </span><span style=\" font-family:'Courier New,courier';\">(Placement(transformation(extent={{-20,140},{0,160}})));</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">  </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.HeatTransfer.Data.OpaqueConstructions.Generic</span><span style=\" font-family:'Courier New,courier';\"> matLayRoo(</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">        material={</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">          </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">HeatTransfer.Data.Solids.InsulationBoard</span><span style=\" font-family:'Courier New,courier';\">(x=0.2),</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">          </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">HeatTransfer.Data.Solids.Concrete</span><span style=\" font-family:'Courier New,courier';\">(x=0.2)},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">        </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">final </span><span style=\" font-family:'Courier New,courier';\">nLay=2) </span><span style=\" font-family:'Courier New,courier'; color:#006400;\">\"Construction material for roof\"</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">annotation </span><span style=\" font-family:'Courier New,courier';\">(Placement(transformation(extent={{20,140},{40,160}})));</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">  </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.HeatTransfer.Data.OpaqueConstructions.Generic</span><span style=\" font-family:'Courier New,courier';\"> matLayFlo(</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">        material={</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">          </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">HeatTransfer.Data.Solids.Concrete</span><span style=\" font-family:'Courier New,courier';\">(x=0.2),</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">          </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">HeatTransfer.Data.Solids.InsulationBoard</span><span style=\" font-family:'Courier New,courier';\">(x=0.1),</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#000000;\">      </span><span style=\" font-family:'Courier New,courier';\">HeatTransfer.Data.Solids.Concrete(x=0.05)</span><span style=\" font-family:'Courier New,courier'; color:#000000;\">}</span><span style=\" font-family:'Courier New,courier';\">,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">        </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">final </span><span style=\" font-family:'Courier New,courier';\">nLay=3) </span><span style=\" font-family:'Courier New,courier'; color:#006400;\">\"Construction material for floor\"</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">annotation </span><span style=\" font-family:'Courier New,courier';\">(Placement(transformation(extent={{60,140},{80,160}})));</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">  </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear</span><span style=\" font-family:'Courier New,courier';\"> glaSys(</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    UFra=2,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    shade=</span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.HeatTransfer.Data.Shades.Gray</span><span style=\" font-family:'Courier New,courier';\">(),</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    haveExteriorShade=false,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    haveInteriorShade=true) </span><span style=\" font-family:'Courier New,courier'; color:#006400;\">\"Data record for the glazing system\"</span></span>
<span style=\" font-family:'Courier New,courier'; color:#0000ff;\">annotation </span><span style=\" font-family:'Courier New,courier';\">(Placement(transformation(extent={{100,140},{120,160}})));</span>

</pre>
<p>
Note that construction layers are assembled from the outside to the room-side. Thus, the construction
<code>matLayRoo</code> has an exterior insulation. This constructions can then be used in the room model.
</p>
<p>
Before we explain how to declare and parametrize a room model,
we explain the different models that can be used to compute heat transfer through the room enclosing surfaces
and constructions. The room model
<a href=\"modelica://Buildings.ThermalZones.Detailed.MixedAir\">Buildings.ThermalZones.Detailed.MixedAir</a> contains the constructions shown
in the table below.
The first row of the table lists the name of the data record that is used by the user
to assign the model parameters.
The second row lists the name of the instance of the model that simulates the equations.
The third column provides a reference to the class definition that implements the equations.
The forth column describes the main applicability of the model.
</p>
<table summary=\"summary\" border=\"1\">
<tr>
<th>Record name</th>
<th>Model instance name</th>
<th>Class name</th>
<th>Description of the model</th></tr>
<tr>
<td>
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.ParameterConstruction\">
datConExt</a>
</td>
<td>
modConExt
</td>
<td>
<a href=\"modelica://Buildings.ThermalZones.Detailed.Constructions.Construction\">Buildings.ThermalZones.Detailed.Constructions.Construction</a>
</td>
<td>
Exterior constructions that have no window.
</td>
</tr>
<tr>
<td>
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.ParameterConstructionWithWindow\">
datConExtWin</a>
</td>
<td>
modConExtWin
</td>
<td>
<a href=\"modelica://Buildings.ThermalZones.Detailed.Constructions.ConstructionWithWindow\">Buildings.ThermalZones.Detailed.Constructions.ConstructionWithWindow</a>
</td>
<td>
Exterior constructions that have a window. Each construction of this type must have one window.
<br/>
Within the same room, all windows can either have an interior shade, an exterior shade or no shade.
Each window has its own control signal for the shade. This signal is exposed by the port <code>uSha</code>, which
has the same dimension as the number of windows. The values for <code>uSha</code> must be between
<code>0</code> and <code>1</code>. Set <code>uSha=0</code> to open the shade, and <code>uSha=1</code>
to close the shade.<br/>
Windows can also have an overhang, side fins, both (overhang and sidefins) or no external shading device.
</td>
</tr>
<tr>
<td>
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.ParameterConstruction\">
datConPar</a>
</td>
<td>
modConPar
</td>
<td>
<a href=\"modelica://Buildings.ThermalZones.Detailed.Constructions.Construction\">Buildings.ThermalZones.Detailed.Constructions.Construction</a>
</td>
<td>
Interior constructions such as partitions within a room. Both surfaces of this construction are inside the room model
and participate in the infrared and solar radiation balance.
Since the view factor between these surfaces is zero, there is no infrared radiation from one surface to the other
of the same construction.
</td>
</tr>
<tr>
<td>
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.ParameterConstruction\">
datConBou</a>
</td>
<td>
modConBou
</td>
<td>
<a href=\"modelica://Buildings.ThermalZones.Detailed.Constructions.Construction\">Buildings.ThermalZones.Detailed.Constructions.Construction</a>
</td>
<td>
Constructions that expose the other boundary conditions of the other surface to the outside of this room model.
The heat conduction through these constructions is modeled in this room model.
The surface at the port <code>opa_b</code> is connected to the models for convection, infrared and solar radiation exchange
with this room model and with the other surfaces of this room model.
The surface at the port <code>opa_a</code> is connected to the port <code>surf_conBou</code> of this room model. This could be used, for example,
to model a floor inside this room and connect to other side of this floor model to a model that computes heat transfer in the soil.
</td>
</tr>
<tr>
<td>
<a href=\"modelica://Buildings.HeatTransfer.Data.OpaqueSurfaces.Generic\">
surBou</a>
</td>
<td>
N/A
</td>
<td>
<a href=\"modelica://Buildings.HeatTransfer.Data.OpaqueSurfaces.Generic\">Buildings.HeatTransfer.Data.OpaqueSurfaces.Generic</a>
</td>
<td>
Opaque surfaces of this room model whose heat transfer through the construction is modeled outside of this room model.
This object is modeled using a data record that contains the area, solar and infrared emissivities and surface tilt.
The surface then participates in the convection and radiation heat balance of the room model. The heat flow rate and temperature
of this surface are exposed at the heat port <code>surf_surBou</code>.
An application of this object may be to connect the port <code>surf_surBou</code> of this room model with the port
<code>surf_conBou</code> of another room model in order to couple two room models.
Another application would be to model a radiant ceiling outside of this room model, and connect its surface to the port
<code>surf_conBou</code> in order for the radiant ceiling model to participate in the heat balance of this room.
</td>
</tr>
</table>
<p>
With these constructions, we may define a room as follows: </p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'Courier New,courier';\">  </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.ThermalZones.Detailed.MixedAir</span><span style=\" font-family:'Courier New,courier';\"> roo(</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">redeclare package</span><span style=\" font-family:'Courier New,courier';\"> Medium = </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">MediumA</span><span style=\" font-family:'Courier New,courier';\">,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    AFlo=6*4,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    hRoo=2.7,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConExt=2,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConExt(layers={matLayRoo, matLayExt},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           A={6*4, 6*3},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           til={Buildings.Types.Tilt.Ceiling, Buildings.Types.Tilt.Wall},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           azi={Buildings.Types.Azimuth.S, Buildings.Types.Azimuth.W}),</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConExtWin=nConExtWin,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConExtWin(layers={matLayExt}, A={4*3},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              glaSys={glaSys},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              hWin={2},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              wWin={2},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              fFra={0.1},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              til={Buildings.Types.Tilt.Wall},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              azi={Buildings.Types.Azimuth.S}),</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConPar=1,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConPar(layers={matLayPar}, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">A=10,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">til=Buildings.Types.Tilt.Wall),</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConBou=1,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConBou(layers={matLayFlo}, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">A=6*4,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">til=Buildings.Types.Tilt.Floor),</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nSurBou=1,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    surBou(</span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">A=6*3, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">absIR=0.9, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">absSol=0.9, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">til=Buildings.Types.Tilt.Wall),</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    linearizeRadiation = true ,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) </span><span style=\" font-family:'Courier New,courier'; color:#006400;\">\"Room model\"</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">annotation </span><span style=\" font-family:'Courier New,courier';\">(Placement(transformation(extent={{46,20},{86,60}})));</span></span>

</pre>
<p>
The following paragraphs explain the " + "different declarations.
</p>
<p>
The statement
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">redeclare package</span><span style=\" font-family:'Courier New,courier';\"> Medium = </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">MediumA</span><span style=\" font-family:'Courier New,courier';\">,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    AFlo=20,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    V=20*2.5,</span></span>

</pre>
<p>
declares that the medium of the room air is set to <code>MediumA</code>,
that the floor area is <i>20 m<sup>2</sup></i> and that
the room air volume is <i>20*2.5 m<sup>3</sup></i>.
The floor area is used to scale the internal heat
gains, which are declared with units of <i>W/m<sup>2</sup></i>
using the input signal <code>qGai_flow</code>.
</p>
<p>
The next entries specify constructions and surfaces
that participate in the heat exchange.
</p>
<p>
The entry
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConExt=2,</span></span>
</pre>
<p>
declares that there are two exterior constructions.
</p>
<p>
The lines
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConExt(layers={matLayRoo, matLayExt},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           A={6*4, 6*3},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           til={Buildings.Types.Tilt.Ceiling, Buildings.Types.Tilt.Wall},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           azi={Buildings.Types.Azimuth.S, Buildings.Types.Azimuth.W}),</span></span>

</pre>
<p>
declare that the material layers in these constructions are
set the records <code>matLayRoo</code> and <code>matLayExt</code>.
What follows are the declarations for the surface area,
the tilt of the surface and the azimuth of the surfaces. Thus, the
surface with construction <code>matLayExt</code> is <i>6*3 m<sup>2</sup></i> large
and it is a west-facing wall.
</p>
<p>
Next, the declaration
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConExtWin=nConExtWin,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConExtWin(layers={matLayExt}, A={4*3},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              glaSys={glaSys},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              hWin={2},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              wWin={2},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0p; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              fFra={0.1},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              til={Buildings.Types.Tilt.Wall},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              azi={Buildings.Types.Azimuth.S}),</span></span>
</pre>
<p>
declares the construction that contains a window. This construction is built
using the materials defined in the record <code>matLayExt</code>. Its total area,
including the window, is <i>4*3 m<sup>2</sup></i>.
The glazing system is built using the construction defined in the record
<code>glaSys</code>. The window area is <i>h<sub>win</sub>=2 m</i> high
and
<i>w<sub>win</sub>=2 m</i> wide.
The ratio of frame
to total glazing system area is <i>10%</i>.
</p>
<p>
Optionally, each window can have an overhang, side fins or both.
If the above window were to have an overhang of
<i>2.5 m</i> width that is centered above the window,
and hence extends each side of the window by <i>0.25 m</i>, and has a depth of
<i>1 m</i> and a gap between window and overhang of
<i>0.1 m</i>, then
its declaration would be
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              ove(wL={0.25}, wR={0.25}, gap={0.1}, dep={1}),</span></span>
</pre>
<p>
This line can be placed below the declaration of <code>wWin</code>.
This would instanciate the model
<a href=\"modelica://Buildings.HeatTransfer.Windows.Overhang\">
Buildings.HeatTransfer.Windows.Overhang</a> to model the overhang. See this class for a picture of the above dimensions.
</p>
<p>
If the window were to have side fins that are
<i>2.5 m</i> high, measured from the bottom of the windows,
and hence extends <i>0.5 m</i> above the window, are
<i>1 m</i> depth and are placed
<i>0.1 m</i> to the left and right of the window,
then its declaration would be
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              sidFin(h={0.5}, gap={0.1}, dep={1}),</span></span>
</pre>
<p>
This would instanciate the model
<a href=\"modelica://Buildings.HeatTransfer.Windows.SideFins\">
Buildings.HeatTransfer.Windows.SideFins</a> to model the side fins. See this class for a picture of the above dimensions.
</p>
<p>
The lines
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              til={Buildings.Types.Tilt.Wall},</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              azi={Buildings.Types.Azimuth.S}),</span></span>
</pre>
<p>
declare that the construction is a wall that is south exposed.
</p>
<p>
Note that if the room were to have two windows, and one window has side fins and the other window has an overhang, the
following declaration could be used, which sets the value of <code>dep</code> to <code>0</code> for the non-present side fins or overhang, respectively:
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              sidFin(h  = {0.5, 0}, gap = {0.1, 0.0}, dep = {1, 0}),</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              ove(wL = {0.0, 0.25}, wR = {0.0, 0.25}, gap = {0.0, 0.1}, dep = {0, 1}),</span></span>
</pre>
<p>
What follows is the declaration of the partition constructions, as declared by
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConPar=1,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConPar(layers={matLayPar}, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">A=10,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">til=Buildings.Types.Tilt.Wall),</span></span>

</pre>
<p>
Thus, there is one partition construction. Its area is <i>10 m<sup>2</sup></i> for <em>each</em>
surface, to form a total surface area inside this thermal zone of <i>20 m<sup>2</sup></i>.
</p>
<p>
Next, the declaration
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConBou=1,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConBou(layers={matLayFlo}, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">A=6*4,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">til=Buildings.Types.Tilt.Floor),</span></span>

</pre>
<p>
declares one construction whose other surface boundary condition is exposed by this
room model (through the heat port <code>surf_conBou</code>).</p>
<p>
Note that by default, there is a temperature state at the surface of this wall.
Therefore, connecting to the heat port  <code>surf_conBou</code> a prescribed
temperature boundary condition such as
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature\">
Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature</a> would lead to an error
and the model won't translate.
The reason is that both, the state defines the temperature at the surface, and
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature\">
Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature</a> prescribes
the value of this temperature, leading
to an overspecification. To avoid this, add between <code>surf_conBou</code>
and the prescribed boundary condition a thermal conductance such as
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Components.ThermalConductor\">
Modelica.Thermal.HeatTransfer.Components.ThermalConductor</a>
or a thermal convection model such as
<a href=\"modelica://Buildings.HeatTransfer.Convection.Exterior\">
Buildings.HeatTransfer.Convection.Exterior</a>.
Alternatively, you could remove the state from the surface by declaring
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConBou=1,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConBou(layers={matLayFlo}, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">A=6*4,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">til=Buildings.Types.Tilt.Floor,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">stateAtSurface_a = false),</span></span>

</pre>

<p>
The declaration
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nSurBou=1,</span></span>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    surBou(</span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">A=6*3, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">absIR=0.9, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">absSol=0.9, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">til=Buildings.Types.Tilt.Wall),</span></span>

</pre>
<p>
is used to instantiate a model for a surface that is in this room.
The surface has an area of <i>6*3 m<sup>2</sup></i>, absorptivity in the infrared and the solar
spectrum of <i>0.9</i> and it is a wall.
The room model will compute infrared radiative heat exchange, solar radiative heat gains
and infrared radiative heat gains of this surface. The surface temperature and
heat flow rate are exposed by this room model at the heat port
<code>surf_surBou</code>.
A model builder may use this construct
to couple this room model to another room model that may model the construction.
</p>
<p>
The declaration
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    linearizeRadiation = true,</span></span>

</pre>
<p>
causes the equations for radiative heat transfer to be linearized. This can
reduce computing time at the expense of accuracy.
</p>
<p>
The declaration
</p>
<pre>
<span style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)</span></span>

</pre>
<p>
is used to initialize the air volume inside the thermal zone.
</p>
<h4>Modeling of contaminants</h4>
<p>
The model has a parameter <code>use_C_flow</code>. If set to <code>true</code>,
then an input connector <code>C_flow</code> is enabled, which allows adding trace substances
to the room air. Note that this requires a medium model that has trace substances enabled.
See the example
<a href=\"modelica://Buildings.ThermalZones.Detailed.Examples.MixedAirCO2\">
Buildings.ThermalZones.Detailed.Examples.MixedAirCO2</a>.
</p>
<h4>Notes</h4>
<p>
To connect two rooms, the model
<a href=\"modelica://Buildings.HeatTransfer.Conduction.MultiLayer\">
Buildings.HeatTransfer.Conduction.MultiLayer</a> can be connected to
the ports <code>surf_surBou</code> of the two rooms.
However, make sure to set <code>stateAtSurface_a = true</code>
and <code>stateAtSurface_b = true</code> in the instance of the heat conduction
model, as this allows to avoid
a nonlinear system of equation to compute the radiative heat transfer,
thereby leading to faster simulation.
See
<a href=\"modelica://Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx.Case960\">
Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx.Case960</a>
for an example.
</p>
<p>
By setting <code>linearizeRadiation = false</code>, nonlinear equations will
be used to compute the infrared radiation exchange among surfaces. This
can lead to slower computation.
</p>
<h4>References</h4>
<p>
<a name=\"WetterEtAl2011\"/>
Michael Wetter, Wangda Zuo and Thierry Stephane Nouidui.<br/>
<a href=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/2011-ibpsa-BuildingsLib.pdf\">
Modeling of Heat Transfer in Rooms in the Modelica \"Buildings\" Library.</a><br/>
Proc. of the 12th IBPSA Conference, p. 1096-1103. Sydney, Australia, November 2011.
</p>
</html>"));
   end MixedAir;

  class CFD
    "Room model with air heat and mass balance computed using Computational Fluid Dynamics"
    extends Modelica.Icons.Information;
  annotation (preferredView="info",
  Documentation(info="<html>
<p>
The model <a href=\"modelica://Buildings.ThermalZones.Detailed.CFD\">
Buildings.ThermalZones.Detailed.CFD</a> is
a room model in which the room air heat and mass balance is computed
using the Computational Fluid Dynamics (CFD).
</p>
<p>
The model is identical with
<a href=\"modelica://Buildings.ThermalZones.Detailed.MixedAir\">
Buildings.ThermalZones.Detailed.MixedAir</a>, except
for the following points:
</p>
<ul>
<li>
The heat and mass balance of the air is computed using CFD.
</li>
<li>
To match surfaces and fluid ports between the Modelica model and the CFD model,
users must declare a unique name for each surface and for each fluid port.
The same names must be used in the CFD input file.
</li>
<li>
To get access to properties of the control volumes in the CFD simulation,
this model allows declaring a sensor using the parameter
<code>sensorName</code>.
This parameter is an array of strings. The same strings must be used
in the CFD input file when declaring the sensor in order to send the
CFD results to the output signal of Modelica.
</li>
<li>
To link the fluid ports in Modelica to the boundary conditions of CFD,
this model requires declaring names for the fluid ports
<code>ports</code> using the parameter
<code>portName</code>.
This parameter is an array of strings. The same strings must be used
in the CFD input file when declaring the inlet and outlet boundary conditions.
</li>
<li>
The control signal of window shades is a constant rather than an input.
Its value cannot be changed during the simulation as the FFD implemementation
does not support moving areas for the boundary conditions.
</li>
<li>
The initial conditions for temperature, mass fraction and trace substances
are declared in the CFD input file rather than in Modelica.
In Modelica, an initial value for the pressure can be defined. This is used
for a pressure balance of the room volume, and is implemented in
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.CFDFluidInterface\">
Buildings.ThermalZones.Detailed.BaseClasses.CFDFluidInterface</a>.
However, the FFD implementation uses
a constant pressure during the whole simulation and does not use the pressure
of the Modelica model.
</li>
</ul>
A description of the model assumptions and the implemention and validation of
this room model can be found in <a href=\"#ZuoEtAl2016\">Zuo et al. (2016)</a>
and in <a href=\"#ZuoEtAl2014\">Zuo et al. (2014)</a>.
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<h4>Conventions</h4>
<p>
The following conventions are made:
</p>
<ul>
<li>
<p>
The port <code>heaPorAir</code> contains the average room air temperature, defined as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  T<sub>a</sub> = 1 &frasl; V &nbsp; &int;<sub>V</sub> T(dV) &nbsp; dV,
</p>
<p>
where <i>T<sub>a</sub></i> is the average room air temperature, <i>V</i> is the room air volume
and <i>T(dV)</i> is the room air temperature in the control volume <i>dV</i>.
The average room air temperature <i>T<sub>a</sub></i> is computed by the CFD program.
</p>
</li>
<li>
If a model injects heat to <code>heaPorAir</code>, then the heat will be distributed to all
cells. The amount of heat flow rate that each cell exchanges with <code>heaPorAir</code> is
proportional to its volume.
</li>
<li>
The flow resistance of the diffusor or exhaust grill must be computed in the
Modelica HVAC system that is connected to the room model, because the CFD
program assumes the same total pressure at all fluid ports.
</li>
</ul>
<p>
The quantities that are exchanged between the programs are defined as follows:
</p>
<ul>
<li>
For the mass flow rate of the fluid port,
we exchange <i>m<sub>e</sub> = 1 &frasl; &Delta; t &int;<sub>&Delta; t</sub> m(s) dt</i>.
</li>
<li>
For the temperature, species concentration and trace substances of the fluid port, we exchange
<i>X = 1 &frasl; (m<sub>e</sub> &nbsp; &Delta; t) &int;<sub>&Delta; t</sub> m(s) &nbsp; X(s) dt</i>.
Note that for the first implementation, CFD does only compute a bulk mass balance for <code>Xi</code>.
It does not do a moisture balance for each cell.
However, for trace substances <code>C</code>, CFD does a contaminant balance for each cell
and return <code>C_outflow</code> to be the contaminant concentration of that cell.
</li>
<li>
For the surface temperatures,
we exchange <i>T<sub>e</sub> = 1 &frasl; &Delta; t &int;<sub>&Delta; t</sub> T(s) dt</i>.
</li>
<li>
For the surface heat flow rates,
we exchange <i>Q<sub>e</sub> = 1 &frasl; &Delta; t &int;<sub>&Delta; t</sub> Q(s) dt</i>.
</li>
</ul>
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<h4>Implementation</h4>
<p>
This section explains how the data exchange between Modelica and CFD is
implemented.
The section is only of interest to developers. Users may skip this section.
</p>
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<h5>Interface to Modelica models</h5>
<p>
Interfacing CFD with the Modelica room air heat and mass balance is done
in the model
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.CFDAirHeatMassBalance\">
Buildings.ThermalZones.Detailed.BaseClasses.CFDAirHeatMassBalance</a>.
To interface variables from Modelica and CFD, the following classes and
conventions are used in this model.
</p>
<ul>
<li>
If a construction is not present, or if no shade is present, or
if no air stream is connected to <code>ports</code>,
then no variables are exchanged for this quantity with the block <code>cfd</code>.
</li>
<li>
For surfaces, heat flow rates in <i>[W]</i> and temperatures
in <i>[K]</i> are exchanged.
These variables are connected to the surface heat ports
through instances of the model
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.CFDSurfaceInterface\">
Buildings.ThermalZones.Detailed.BaseClasses.CFDSurfaceInterface</a>.
This model has four ports.
Depepending on the parameter
<code>bouCon</code>, two of these ports are conditionally removed.
This allows to use the parameter <code>bouCon</code> to specify whether
the surface should be used with a temperature or a heat flow rate
boundary condition.
Therefore, the inputs and outputs to the instance <code>cfd</code>
are either temperatures or heat flow rates.
The parameter <code>surIde</code> of this model, which is also
propagated to the instance <code>cfd</code>, declares what
type of boundary condition is used.
</li>
<li>
The variables of the connector <code>ports</code> are exchanged with the CFD block
through the instance <code>intFlu</code>.
This interface is implemented in
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.CFDFluidInterface\">
Buildings.ThermalZones.Detailed.BaseClasses.CFDFluidInterface</a>.
Its output and input signals are connected to the <code>cfd</code> block as follows:
<ul>
<li>
Input to the <code>cfd</code> block is a vector
<code>[p, m_flow[nPorts], T_inflow[nPorts], X_inflow[nPorts*Medium.nXi],
C_inflow[nPorts*Medium.nC]]</code>.
The quantity <code>p</code> is the total pressure of the fluid ports (all fluid ports have the same
total pressure).
Therefore, the flow resistance of the diffusor or exhaust grill must be computed in the
Modelica HVAC system that is connected to the room model.
The quantities <code>X_inflow</code> and <code>C_inflow</code> (or <code>X_inflow</code> and <code>C_inflow</code>)
are vectors with components <code>X_inflow[1:Medium.nXi]</code> and <code>C_inflow[1:Medium.nC]</code>.
For example, for moist air, <code>X_inflow</code> has one element which is equal to the mass fraction of air,
relative to the total air mass and not the dry air.
</li>
<li>
Output from the CFD block is a vector
<code>[T_outflow[nPorts], X_outflow[nPorts*Medium.nXi], C_outflow[nPorts*Medium.nC]]</code>.
The quantities <code>*_outflow</code> are the fluid properties of the cell to which the port is
connected.
</li>
<li>
If <code>Medium.nXi=0</code> (e.g., for dry air) or <code>Medium.nC=0</code>,
then these signals are not present as input/output signals of the CFD block.
</li>
</ul>
</ul>
<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
<h5>Data exchange with CFD</h5>
<p>
The data exchange with the CFD interface is done through the instance
<code>cfd</code>, and implemented in
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.CFDExchange\">
Buildings.ThermalZones.Detailed.BaseClasses.CFDExchange</a>.
This block exchanges the following data with the CFD simulation:
</p>
<p>
During the initialzation, the following data are sent from Modelica to CFD:
</p>
<ul>
<li>
An array of strings where each element is the name of the surface,
as declared by
the user when instantiating the model
<a href=\"Buildings.ThermalZones.Detailed.CFD\">Buildings.ThermalZones.Detailed.CFD</a>.
Let us call this array <code>name</code>.
The orders of elements in this array are as follows:
<ol>
<li>
The first
<code>nConExt</code> elements are the names of the exterior constructions
declared as <code>datConExt</code>. The order is the same as
in the declaration of <code>datConExt</code>.
</li>
<li>
<code>nConExtWin</code> elements are the names of the exterior constructions
declared as <code>datConExtWin</code>. These constructions embed windows
and a frame. Therefore, what follows are
<code>nConExtWin</code> elements where each string is the same as above,
but <code>' (glass, unshaded)'</code> has been appended,
then -- if and only if the window has a shade --
<code>nConExtWin</code> elements follow with
<code>' (glass, shaded)'</code> appended, and,
finally,
<code>nConExtWin</code> elements follow with <code>' (frame)'</code> appended.
</li>
<li>
<code>nConPar</code> elements for the surface <code>a</code> of <code>datConPar</code>.
To these names, the string <code>' (surface a)'</code> is appended.
Next, there are <code>nConPar</code> elements with  <code>' (surface b)'</code> appended.
</li>
<li>
<code>nConBou</code> elements for the surfaces of <code>datConBou</code>.
</li>
<li>
<code>nSurBou</code> elements for the surfaces of <code>nSurBou</code>.
</li>
</ol>
</li>
<li>
Using the same order, there is also an array for the areas of the surfaces <code>A</code>,
an array for the surface tilt <code>til</code>
and the type of the boundary conditions <code>bouCon</code> for each of these surfaces.
If <code>bouCon[i] = 1</code>,
then temperature is sent from Modelica to CFD.
If <code>bouCon[i] = 2</code>, then
heat flow rate is sent from Modelica to CFD.
</li>
<li>
There is an array <code>sensorName</code> that contains the names of all sensors,
in the same order as they are declared when instantiating the model
<a href=\"modelica://Buildings.ThermalZones.Detailed.CFD\">
Buildings.ThermalZones.Detailed.CFD</a>.
If no sensors are declared in Modelica, then this array will have zero elements.
How many sensor are declared in Modelica can be checked through the variable <code>nSen</code>,
which is sent from Modelica to CFD.
</li>
<li>
There is also an array <code>AirProperty</code> that contains the properties of the air.
The orders of elements in this array are as follows:
<ol>
<li>
The density of air at the initial state (CFD will accept it only when there is a mass exchange between the two programs).
</li>
</ol>
</li>
</ul>
<p>
During the time integration, and array <code>u</code> is sent from Modelica to CFD, and Modelica
receives an array <code>y</code> from CFD.
The elements of the array <code>u</code> are as follows:
</p>
<ol>
<li>
Either temperature or heat flow rate boundary conditions,
in the same order as the array <code>name</code>. The units are <i>[K]</i> or <i>[W]</i>.
The array <code>bouCon</code> that is sent during the
initialization declares the type of boundary
condition.
There are <code>nSur</code> elements for surfaces.
</li>
<li>
If at least one window in the room has a shade, then the next
<code>nConExtWin</code>
elements are the shading control signals. <code>u=0</code> means
that the shade is not deployed,
and <code>u=1</code> means that the shade is
completely deployed (blocking solar radiation).
If there is no window in the room, then these elements are not present.
</li>
<li>
If at least one window in the room has a shade, then the next <code>nConExtWin</code>
elements are the radiations in <i>[W]</i> that are absorbed by the
respective shades.
If there is no window in the room, then these elements are not present.
</li>
<li>
The convective sensible heat input into the room in <i>[W]</i>, which is a scalar.
A positive value means that heat is added to the room.
</li>
<li>
The latent heat input into the room in <i>[W]</i>, which is a scalar.
A positive value means that moisture is added to the room.
</li>
<li>
The next element is the room average static pressure in <i>[Pa]</i>.
</li>
<li>
The next <code>nPorts</code> elements are the mass flow rates
into the room in <i>[kg/s]</i>.
A positive value is used if the air flows into the room,
otherwise the value is negative.
The first element is connected to <code>ports[1]</code>, the second to
<code>ports[2]</code> etc.
</li>
<li>
The next <code>nPorts</code> elements are the air temperatures
that the medium has
<i>if it were flowing into the room</i>, e.g., the \"inflowing medium\"
computed based on <code>inStream(h_outflow)</code>.
</li>
<li>
The next <code>nPorts*Medium.nXi</code> elements are the
species concentration of the inflowing
medium.
The first <code>Medium.nXi</code> elements are for port <i>1</i>, then for
port <i>2</i> etc.
The units are in <i>[kg/kg]</i> total mass, and not in  <i>[kg/kg]</i> dry air.
</li>
<li>
The next <code>nPorts*Medium.nC</code> elements are the trace substances
of the inflowing
medium.
The first <code>Medium.nC</code> elements are for port <i>1</i>, then for
port <i>2</i> etc.
</li>
</ol>
The elements of the array <code>y</code> that is sent from CFD to Modelica are as follows:
<ol>
<li>
Either temperature or heat flow rate at the surfaces,
in the same order as the array <code>name</code>.
The array <code>bouCon</code> that is sent during the
initialization declares the type of boundary
condition.
If <code>bouCon[i] = 1</code>, then heat flow rate in <i>[W]</i>
is sent from CFD to Modelica.
If <code>bouCon[i] = 2</code>, then temperature in <i>[K]</i>
is sent from CFD to Modelica.
There are <code>nSur</code> elements for surfaces.
</li>
<li>
The average room air temperature in <i>[K]</i>.
</li>
<li>
If the room has at least one window with a shade, then the next
<code>nConExtWin</code> elements are the temperature of the
shade in <i>[K]</i>.
</li>
<li>
The next <code>nPorts</code> elements are the air temperatures
in <i>[K]</i>
of the cells that are connected to the inlet or outlet diffusor
of <code>ports[1], ports[2], etc.</code>.
</li>
<li>
The next <code>nPorts*Medium.nXi</code> elements are the
species concentration of the cells to which the ports are
connected.
The first <code>Medium.nXi</code> elements are for port <i>1</i>, then for
port <i>2</i> etc.
The units are in <i>[kg/kg]</i> total mass, and not in <i>[kg/kg]</i> dry air.
</li>
<li>
The next <code>nPorts*Medium.nC</code> elements are the trace substances
of the cells to which the ports are connected to.
The first <code>Medium.nC</code> elements are for port <i>1</i>, then for
port <i>2</i> etc.
</li>
</ol>
<h4>References</h4>
<p>
<a name=\"ZuoEtAl2016\"/>
Wangda Zuo, Michael Wetter, Wei Tian, Dan Li, Mingang Jin, Qingyan Chen.<br/>
<a href=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/FFD/Zuo2016.pdf\">
Coupling Indoor Airflow, HVAC, Control and Building Envelope Heat Transfer in the Modelica Buildings Library.
</a>
<br/>
Journal of Building Performance Simulation, 9(4), pp. 366-381, 2016.<br/>
<a href=\"http://dx.doi.org/10.1080/19401493.2015.1062557\">
http://dx.doi.org/10.1080/19401493.2015.1062557</a>.
</p>
<p>
<a name=\"ZuoEtAl2014\"/>
Wangda Zuo, Michael Wetter, Dan Li, Mingang Jin, Wei Tian, Qingyan Chen.<br/>
<a href=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/FFD/ZuoEtAl2014.pdf\">
Coupled Simulation of Indoor Environment, HVAC and Control System by Using Fast Fluid Dynamics and the Modelica Buildings Library. </a><br/>
Proc. of the 2014 ASHRAE/IBPSA-USA Building Simulation Conference, Atlanta, GA, September 10-12, 2014.
</p>
</html>"));
  end CFD;
  annotation (preferredView="info",
  Documentation(info="<html>
<p>
The package <a href=\"modelica://Buildings.ThermalZones.Detailed\">Buildings.ThermalZones.Detailed</a> contains models for heat transfer
through the building envelope.
Multiple instances of these models can be connected to create
a multi-zone building model.
To compute the air exchange between rooms and between a room
and the exterior, the room models can be connected to
multi-zone air exchange models from the package
<a href=\"modelica://Buildings.Airflow\">
Buildings.Airflow</a>.
The room models can also be linked to models of HVAC systems
that are composed of the components in the package
<a href=\"modelica://Buildings.Fluid\">
Buildings.Fluid</a>.
</p>
<p>
There are two different room models, one assumes the room air to be completely
mixed, and the other implements a computuational fluid dynamic model to compute
air flow, temperature and species distribution inside the room.
These models are further described in their respective user's guide,
<a href=\"modelica://Buildings.ThermalZones.Detailed.UsersGuide.MixedAir\">Buildings.ThermalZones.Detailed.UsersGuide.MixedAir</a>
and
<a href=\"modelica://Buildings.ThermalZones.Detailed.UsersGuide.CFD\">Buildings.ThermalZones.Detailed.UsersGuide.CFD</a>.
</p>
<h4>Modeling of conventional and electrochromic windows</h4>
<p>
Both models have the option of modeling electrochromic windows.
The window properties are specified in a record
<a href=\"modelica://Buildings.HeatTransfer.Data.GlazingSystems\">Buildings.HeatTransfer.Data.GlazingSystems</a>
which contains for the glass layer the record
<a href=\"modelica://Buildings.HeatTransfer.Data.Glasses\">Buildings.HeatTransfer.Data.Glasses</a>.
If any glass layer has multiple properties, then the glass is assumed to be controllable,
and the room model will have an input connector
<code>uWin</code> that is used for the control input signal of the glass.
This connnector is a vector in which each element is a control signal,
with value between <i>0</i> and <i>1</i>, for a particular window.
Hence, either all or none of the windows must be electrochromic.
(If your room has a mixture of conventional and electrochromic windows, then set
all windows to be electrochromic, but simply use a constant control signal for the
conventional windows, and set it to the off-state.)
If all windows are conventional, then the connector <code>uWin</code> is removed.
However, its icon may still be visible as the visual rendering engine may not evaluate
the equations that are needed to determine whether there are controllable windows.
</p>
<p>
The model
<a href=\"modelica://Buildings.ThermalZones.Detailed.Examples.ElectroChromicWindow\">
Buildings.ThermalZones.Detailed.Examples.ElectroChromicWindow</a>
shows how to configure electrochromic windows.
</p>
<h4>Experimental settings</h4>
<p>
Both models have the option to time sample the heat transfer calculation.
Setting the parameter <code>sampleModel</code> samples the radiative heat transfer
with a sampling time of <i>2</i> minutes. This can give shorter simulation time
if there is already a time sampling in the system model.
This option is experimental and may be changed or removed in future versions.
</p>
</html>"));
end UsersGuide;
