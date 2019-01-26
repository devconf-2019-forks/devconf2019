package solarwinds.luncher;

public class VotedDto {
    private String placeName;
    private Integer dbId;
    private String auth;

    public VotedDto(Integer dbId, String placeName, String auth) {
        this.dbId = dbId;
        this.placeName = placeName;
        this.auth = auth;
    }

    public String getPlaceName() {
        return placeName;
    }

    public Integer getDbId() {
        return dbId;
    }

    public String getAuth() {
        return auth;
    }
}
