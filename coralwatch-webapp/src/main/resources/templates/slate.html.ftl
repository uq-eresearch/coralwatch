<script type="text/javascript">
    $('#slate-${colorFieldId}').ready(function()
    {
        $('.colored-${colorFieldId}').each(function()
        {
            $(this).click(function() {
                $('#${colorFieldId}').val($(this).text());
            });
        });
    });
</script>
<table class="slate" id="slate-${colorFieldId}">
    <tr>
        <td class="colored-${colorFieldId}" style="background-color:#ffffff">B1</td>
        <td class="colored-${colorFieldId}" style="background-color:#ccffcc;">B2</td>
        <td class="colored-${colorFieldId}" style="background-color:#99ff99;">B3</td>
        <td class="colored-${colorFieldId}" style="background-color:#66cc00;">B4</td>
        <td class="colored-${colorFieldId}" style="background-color:#339900;">B5</td>
        <td class="colored-${colorFieldId}" style="background-color:#006600;">B6</td>
        <td class="colored-${colorFieldId}" style="background-color:#ffffff">C1</td>
    </tr>
    <tr>
        <td class="colored-${colorFieldId}" style="background-color:#333300;">E6</td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td class="colored-${colorFieldId}" style="background-color:#ffcccc;">C2</td>
    </tr>
    <tr>
        <td class="colored-${colorFieldId}" style="background-color:#666600;">E5</td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td class="colored-${colorFieldId}" style="background-color:#ff6666;">C3</td>
    </tr>
    <tr>
        <td class="colored-${colorFieldId}" style="background-color:#666600;">E4</td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td class="colored-${colorFieldId}" style="background-color:#cc3300;">C4</td>
    </tr>
    <tr>
        <td class="colored-${colorFieldId}" style="background-color:#999900;">E3</td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td class="colored-${colorFieldId}" style="background-color:#993300;">C5</td>
    </tr>
    <tr>
        <td class="colored-${colorFieldId}" style="background-color:#cccc00;">E2</td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td class="colored-${colorFieldId}" style="background-color:#330000;">C6</td>
    </tr>
    <tr>
        <td class="colored-${colorFieldId}" style="background-color:#ffffff;">E1</td>
        <td class="colored-${colorFieldId}" style="background-color:#330000;">D6</td>
        <td class="colored-${colorFieldId}" style="background-color:#663300;">D5</td>
        <td class="colored-${colorFieldId}" style="background-color:#993300;">D4</td>
        <td class="colored-${colorFieldId}" style="background-color:#ff9933;">D3</td>
        <td class="colored-${colorFieldId}" style="background-color:#ffcc99;">D2</td>
        <td class="colored-${colorFieldId}" style="background-color:#ffffff;">D1</td>
    </tr>
</table>                                                             