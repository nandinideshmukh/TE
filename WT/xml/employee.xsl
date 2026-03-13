<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="sortOrder" select="'ascending'" />
  <xsl:param name="searchName" select="''" />

  <xsl:template match="/">
    <html>
      <head>
        <style>
          table { border-collapse: collapse; width: 100%; }
          th, td { border: 1px solid black; padding: 8px; text-align: left; }
          th { background-color: #9acd32; }
        </style>
      </head>
      <body>
        <h2>Employee List</h2>
        <table>
          <tr>
            <th>Name</th>
            <th>id</th>
            <th>Email</th>
            <th>Position</th>
            <th>Department</th>
            <th>Salary</th>
            <th>Joining Date</th>
            <th>Age</th>
            <th>Gender</th>
            <th>Experience</th>
          </tr>
          <xsl:for-each
            select="employees/employee[contains(translate(name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),
                                                   translate($searchName,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'))]">
            <xsl:sort select="id" data-type="number" order="{$sortOrder}" />
    
            <tr>
              <td>
                <xsl:value-of select="name" />
              </td>
              <td>
                <xsl:value-of select="id" />
              </td>
              <td>
                <xsl:value-of select="email" />
              </td>
              <td>
                <xsl:value-of select="position" />
              </td>
              <td>
                <xsl:value-of select="department" />
              </td>
              <td>
                <xsl:attribute name="style">
                  <xsl:choose>
                    <xsl:when test="salary &gt; 80000">background-color:#90EE90;</xsl:when>
                    <xsl:when test="salary &gt;= 50000 and salary &lt;= 100000">
    background-color:#FFFF99;</xsl:when>
                    <xsl:otherwise>background-color:#FF7F7F;</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="salary" />
              </td>
              <td>
                <xsl:value-of select="joining_date" />
              </td>
              <td>
                <xsl:value-of select="age" />
              </td>
              <td>
                <xsl:value-of select="gender" />
              </td>
              <td>
                <xsl:value-of select="experience" />
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
