package solarwinds.luncher;

import org.springframework.web.bind.annotation.*;
import solarwinds.luncher.dto.ClusterDto;
import solarwinds.luncher.entity.Cluster;
import solarwinds.luncher.entity.Vote;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.transaction.Transactional;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@RestController
public class LuncherController {

    @PersistenceContext
    private EntityManager em;

    @GetMapping
    @RequestMapping("/clusters")
    public List<ClusterDto> getClusters() {
        //Dummy
        List<ClusterDto> clusters = new ArrayList<>();
        clusters.add(new ClusterDto("Kometa", Arrays.asList("Filip", "Jirka", "Martin")));
        clusters.add(new ClusterDto("Indicka", Arrays.asList("Tomas", "Honza")));

        return clusters;
    }

    @PostMapping
    @Transactional
    @RequestMapping("/vote/{placeName}")
    public VotedDto vote(@RequestHeader(name="auth") String auth, @PathVariable String placeName) {
        Vote vote = new Vote();
        em.persist(vote); // just a dummy vote
        return new VotedDto(vote.getId(), placeName, auth);
    }

    @GetMapping
    @RequestMapping("/places")
    public List<String> getPlaces() {
        return Arrays.asList("Indicka", "Kometa");
    }
}
