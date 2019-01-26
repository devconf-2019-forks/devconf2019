package solarwinds.luncher.dto;

import java.util.List;

public class ClusterDto {
    private String place;
    private List<String> users;

    public ClusterDto(String place, List<String> users) {
        this.place = place;
        this.users = users;
    }

    public String getPlace() {
        return place;
    }

    public void setPlace(String place) {
        this.place = place;
    }

    public List<String> getUsers() {
        return users;
    }

    public void setUsers(List<String> users) {
        this.users = users;
    }
}
