<#if testMode>
<h1 style="color:red;">
    <blink>TEST MODE</blink>
</h1>
</#if>
<script>
    if (document.images) {
        stfirstON = new Image();
        stfirstOFF = new Image();
        stfirstON.src = "${baseUrl}/images/stag_healthy2.jpg";
        stfirstOFF.src = "${baseUrl}/images/stag_bleached2.jpg";
        brfirstON = new Image();
        brfirstOFF = new Image();
        brfirstON.src = "${baseUrl}/images/brain_healthy2.jpg";
        brfirstOFF.src = "${baseUrl}/images/brain_bleached2.jpg";
        plfirstON = new Image();
        plfirstOFF = new Image();
        plfirstON.src = "${baseUrl}/images/plate_healthy2.jpg";
        plfirstOFF.src = "${baseUrl}/images/plate_bleached2.jpg";
        sofirstON = new Image();
        sofirstOFF = new Image();
        sofirstON.src = "${baseUrl}/images/heronreef_healthy.jpg";
        sofirstOFF.src = "${baseUrl}/images/heronreef_bleached.jpg";
    }
    function imgOn(imgName) {
        if (document.images) {
            document[imgName].src = eval(imgName + "ON.src");
        }
    }
    function imgOff(imgName) {
        if (document.images) {
            document[imgName].src = eval(imgName + "OFF.src");
        }
    }
</script>

<a href="http://www.iyor.org/" target="_blank"><img name="IYOR" src="${baseUrl}/images/iyor.bmp" align="right"
                                                    alt="IYOR Logo" class="right"></a>

<p>
    CoralWatch is an organisation built on a research project at the University of Queensland,
    Brisbane, Australia. We have developed a cheap, simple, non-invasive method for
    the monitoring of coral bleaching, and assessment of coral health. Our Coral Health
    Chart is basically a series of sample colours, with variation in brightness representing
    different stages of bleaching/recovery, based on controlled experiments.
</p>
<div style="margin-left: 10px; margin-bottom: 10px; float: right; width:30%;">
    <div class="border">
        <div class="btall">
            <div class="ltall">

                <div class="rtall">
                    <div class="tleft">
                        <div class="tright">
                            <div class="bleft">
                                <div class="bright">
                                    <#--<div class="ind">-->
                                    <div class="h_text">
                                        <h3>CoralWatch News</h3>
                                    </div>
                                    <div style="padding:5px; text-align:justify;">
                                        <ul class="news-list">
                                            <li><a>The new CoralWatch website is now live and ready for users to sign
                                                up.</a></li>
                                        </ul>
                                    </div>
                                    <#--</div>-->
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<p>
    In the field, users simply compare colours of corals with colours on the chart and
    record matching codes. The charts can be used by anyone - scientists, school children,
    tourists and politicians.
</p>
<p>
    It is our aim to both provide a scientific tool and increase awareness about global
    warming by demonstrating one of its devastating effects. We ask you to please help
    by using our kit to monitor your local reefs, or any that you visit.
</p>
<p>
    CoralWatch have also joined forces with Project AWARE Foundation, a nonprofit environmental
    organisation working with divers to conserve underwater environments through education,
    advocacy and action. Project AWARE have registered over 500 CoralWatch monitoring
    locations worldwide making it easy for <a
        href="http://www.projectaware.org/asiapac/english/activities/coral_monitoring.asp"
        target="_blank">divers and snorkelers to get involved</a>. You
    can view a list of <a href="http://www.projectaware.org/americas/english/coral-watch/list.asp" target="_blank">
    participating dive centres</a> or find out more by visiting <a
        href="http://www.projectaware.org/asiapac/english/activities/coral_monitoring.asp" target="_blank">Project
    AWARE</a>
</p>

<p>
    You can request a free* DIY Coral Health Monitoring Kit by contacting us at <a href="mailto:info@coralwatch.org">info@coralwatch.org</a>.
    The chart is currently available in English, Chinese, simplified Chinese, Japanese
    and French with more languages becoming available in 2008!&nbsp;
</p>

<p>
    We now have a link to NOAAs' Tropical Ocean Coral Bleaching Indices Page! Here,
    you can immediately see which Coral Reefs are currently under Bleaching Alert, for
    further details <a href="http://www.osdpd.noaa.gov/PSB/EPS/CB_indices/coral_bleaching_indices.html" target="_blank">click
    here</a>.
    <br/>
    <br/>
    * First kit provided free of charge.
</p>
<p>
    Move the mouse over a picture to see the difference between healthy (original picture)
    and bleached coral
</p>

<table class="frontTable">
    <tr>
        <td>
            <table cellpadding="1">
                <tbody>
                <tr>
                    <td>
                        <img name="stfirst" src="${baseUrl}/images/stag_healthy2.jpg"
                             onmouseover="imgOff('stfirst')"
                             onmouseout="imgOn('stfirst')">
                    </td>

                </tr>
                <tr>
                    <td class="smalltext" align="center">
                        Branching Coral (br)
                    </td>
                </tr>
                </tbody>
            </table>
        </td>

        <td>
            <table cellpadding="1">
                <tbody>
                <tr>
                    <td>
                        <img onmouseover="imgOff('brfirst')" onmouseout="imgOn('brfirst')"
                             src="${baseUrl}/images/brain_healthy2.jpg"
                             name="brfirst">
                    </td>
                </tr>
                <tr>

                    <td class="smalltext" align="center">
                        Boulder Coral (bo)
                    </td>
                </tr>
                </tbody>
            </table>
        </td>
        <td>
            <table cellpadding="1">

                <tbody>
                <tr>
                    <td>
                        <img onmouseover="imgOff('plfirst')" onmouseout="imgOn('plfirst')"
                             src="${baseUrl}/images/plate_healthy2.jpg"
                             name="plfirst">
                    </td>
                </tr>
                <tr>
                    <td class="smalltext" align="center">
                        Plate Coral (pl)
                    </td>

                </tr>
                </tbody>
            </table>
        </td>
        <td>
            <table cellpadding="1">
                <tbody>
                <tr>
                    <td>

                        <img onmouseover="imgOff('sofirst')" onmouseout="imgOn('sofirst')"
                             src="${baseUrl}/images/heronreef_healthy.jpg"
                             name="sofirst">
                    </td>
                </tr>
                <tr>
                    <td class="smalltext" align="center">
                        Heron Island
                    </td>
                </tr>
                </tbody>

            </table>
        </td>
    </tr>
</table>
<br/>
<p class="small">
    NOTE<br/>
    Coral type terminology has been refined to better represent the coral types present
    on reefs, as per feedback received from marine educators. "Staghorn" coral type
    changes to "branching" and "brain" changes to "boulder". All coral types will now
    have a two letter code, for example soft will be represented by "so". During the
    change of period you may need to use staghorn and branching interchangeably, and
    likewise for brain and boulder - please bear with us during this transition period.
    If you have any queries or comments please email <a href="mailto:info@coralwatch.org" style="font-size:10px;">info@coralwatch.org</a>
</p>
